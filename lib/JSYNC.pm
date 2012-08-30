##
# name:      JSYNC
# abstract:  JSON YAML Notation Coding
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2010, 2011, 2012
# see:
# - http://www.jsync.org/
# - JSON
# - YAML
# - irc.freenode.net#jsync

use 5.008003;
use strict;
use warnings;

use JSON 2.53;

package JSYNC;

our $VERSION = '0.14';

my $next_anchor;
my $seen;

sub dump {
    $next_anchor = 1;
    $seen = {};
    my $object = shift;
    my $config = shift || {};
    my $repr = _represent($object);
    my $json = 'JSON'->new()->canonical();
    if ($config->{pretty}) {
        $json->pretty();
    }
    my $jsync = $json->encode($repr);
    return $jsync;
}

sub load {
    $seen = {};
    my $jsync = shift;
    my $repr = 'JSON'->new()->decode($jsync);
    my $object = _construct($repr);
    return $object;
}

sub _info {
    if (ref(\$_[0]) eq 'GLOB') {
        (\$_[0] . "") =~ /^(?:(.+)=)?(GLOB)\((0x.*)\)$/
            or die "Can't get info for '$_[0]'";
        return ($3, lc($2), $1 || '');
    }
    if (not ref($_[0])) {
        return (undef, 'scalar', undef);
    }
    "$_[0]" =~ /^(?:(.+)=)?(HASH|ARRAY)\((0x.*)\)$/
        or die "Can't get info for '$_[0]'";
    return ($3, lc($2), $1 || '');
}

sub _represent {
    my $node = shift;
    my $repr;
    my ($id, $kind, $class) = _info($node);
    if ($kind eq 'scalar') {
        if (not defined $node) {
            return undef;
        }
        return _escape($node);
    }
    if (my $info = $seen->{$id}) {
        if (not $info->{anchor}) {
            $info->{anchor} = $next_anchor++ ."";
            if ($info->{kind} eq 'hash') {
                $info->{repr}{'&'} = $info->{anchor};
            }
            else {
                unshift @{$info->{repr}}, '&' . $info->{anchor};
            }
        }
        return "*" . $info->{anchor};
    }
    my $tag = _resolve_to_tag($kind, $class);
    if ($kind eq 'array') {
        $repr = [];
        $seen->{$id} = { repr => $repr, kind => $kind };
        @$repr = map { _represent($_) } @$node;
        if ($tag) {
            unshift @$repr, "!$tag";
        }
    }
    elsif ($kind eq 'hash') {
        $repr = {};
        $seen->{$id} = { repr => $repr, kind => $kind };
        for my $k (keys %$node) {
            $repr->{_represent($k)} = _represent($node->{$k});
        }
        if ($tag) {
            $repr->{'!'} = $tag;
        }
    }
    elsif ($kind eq 'glob') {
        $class ||= 'main';
        $repr = {};
        $repr->{PACKAGE} = $class;
        $repr->{'!'} = '!perl/glob:';
        for my $type (qw(PACKAGE NAME SCALAR ARRAY HASH CODE IO)) {
            my $value = *{$node}{$type};
            $value = $$value if $type eq 'SCALAR';
            if (defined $value) {
                if ($type eq 'IO') {
                    my @stats = qw(device inode mode links uid gid rdev size
                                   atime mtime ctime blksize blocks);
                    undef $value;
                    $value->{stat} = {};
                    map {$value->{stat}{shift @stats} = $_} stat(*{$node});
                    $value->{fileno} = fileno(*{$node});
                    {
                        local $^W;
                        $value->{tell} = tell(*{$node});
                    }
                }
                $repr->{$type} = $value;
            }
        }

    }
    else {
        # XXX [$id, $kind, $class];
        die "Can't represent kind '$kind'";
    }
    return $repr;
}

sub _construct {
    my $repr = shift;
    my $node;
    my ($id, $kind, $class) = _info($repr);
    if ($kind eq 'scalar') {
        if (not defined $repr) {
            return undef;
        }
        if ($repr =~ /^\*(\S+)$/) {
            return $seen->{$1};
        }
        return _unescape($repr);
    }
    if ($kind eq 'hash') {
        $node = {};
        if ($repr->{'&'}) {
            my $anchor = $repr->{'&'};
            delete $repr->{'&'};
            $seen->{$anchor} = $node;
        }
        if ($repr->{'!'}) {
            my $class = _resolve_from_tag($repr->{'!'});
            delete $repr->{'!'};
            bless $node, $class;
        }
        for my $k (keys %$repr) {
            $node->{_unescape($k)} = _construct($repr->{$k});
        }
    }
    elsif ($kind eq 'array') {
        $node = [];
        if (@$repr and defined $repr->[0] and $repr->[0] =~ /^!(.*)$/) {
            my $class = _resolve_from_tag($1);
            shift @$repr;
            bless $node, $class;
        }
        if (@$repr and $repr->[0] and $repr->[0] =~ /^\&(\S+)$/) {
            $seen->{$1} = $node;
            shift @$repr;
        }
        @$node = map {_construct($_)} @$repr;
    }
    return $node;
}

sub _resolve_to_tag {
    my ($kind, $class) = @_;
    return $class && "!perl/$kind\:$class";
}

sub _resolve_from_tag {
    my ($tag) = @_;
    $tag =~ m{^!perl/(?:hash|array|object):(\S+)$}
      or die "Can't resolve tag '$tag'";
    return $1;
}

sub _escape {
    my $string = shift;
    $string =~ s/^(\.*[\!\&\*\%])/.$1/;
    return $string;
}

sub _unescape {
    my $string = shift;
    $string =~ s/^\.(\.*[\!\&\*\%])/$1/;
    return $string;
}

1;

=head1 STATUS

This is a very early release of JSYNC, and should not be used at all
unless you know what you are doing.

Supported so far:
- dump and load of the basic JSON model
- dump and load of duplicate references
- dump and load recursive references
- dump and load typed mappings and sequences
- escaping of special keys and values
- dump globs
- add json pretty printing

=head1 SYNOPSIS

    use JSYNC;

    my $object = <any perl expression>
    my $jsync = JSYNC::dump($object, {pretty => 1});
    $object = JSYNC::load($jsync);

=head1 DESCRIPTION

JSYNC is an extension of JSON that can serialize any data objects.
