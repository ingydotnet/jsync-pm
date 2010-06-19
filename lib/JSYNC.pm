package JSYNC;
use 5.008003;
use strict;
use warnings;

use JSON;
# use XXX; # -with => 'Data::Dumper';

our $VERSION = '0.02';

my $next_anchor;
my $seen;

sub dump {
    $next_anchor = 1;
    $seen = {};
    my $object = shift;
    my $repr = _represent($object);
    my $jsync = 'JSON'->new()->canonical()->encode($repr);
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
                WWW $info;
                unshift @{$info->{repr}}, '&' . $info->{anchor};
            }
        }
        return "*" . $info->{anchor};
    }
    if ($kind eq 'array') {
        $repr = [ map { _represent($_) } @$node ];
    }
    elsif ($kind eq 'hash') {
        $repr = {};
        for my $k (keys %$node) {
            $repr->{$k} = _represent($node->{$k});
        }
    }
    else {
        die "Can't represent kind '$kind'";
        # XXX [$id, $kind, $class];
    }
    $seen->{$id} = {
        repr => $repr,
        kind => $kind,
    };
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
        for my $k (keys %$repr) {
            $node->{$k} = _construct($repr->{$k});
        }
    }
    elsif ($kind eq 'array') {
        $node = [];
        if (@$repr and $repr->[0] and $repr->[0] =~ /^\&(\S+)$/) {
            $seen->{$1} = $node;
            shift @$repr;
        }
        @$node = map {_construct($_)} @$repr;
    }
    return $node;
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

=head1 NAME

JSYNC - JSON YAML Notation Coding

=head1 STATUS

This is a very early release of JSYNC, and should not be used at all
unless you know what you are doing.

Supported so far:
* dump and load of things JSON handles.
* dump and load of duplicate references.

=head1 SYNOPSIS

    use JSYNC;

    my $object = <any perl expression>
    my $jsync = JSYNC::dump($object);
    $object = JSYNC::load($jsync);

=head1 DESCRIPTION

JSYNC is an extension of JSON that can serialize any data objects.

See http://www.jsync.org/

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2010. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
