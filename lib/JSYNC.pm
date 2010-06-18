package JSYNC;
use 5.008003;
use strict;
use warnings;

use JSON;
# use XXX -with => 'Data::Dumper';

our $VERSION = '0.01';

sub dump {
    my $object = shift;
    return 'JSON'->new()->canonical()->encode($object);
}

sub load {
    my $jsync = shift;
    return 'JSON'->new()->decode($jsync);
}

1;

=head1 NAME

JSYNC - JSON YAML Notation Coding

=head1 SYNOPSIS

    use JSYNC;

    my $object = <any perl expression>
    my $jsync = JSYNC::dump($object);
    $object = JSYNC::load($jsync);

=head1 DESCRIPTION

JSYNC is an extension of JSON that can serialize any data objects.

See http://www.jsync.org/

=head1 STATUS

This is a very early release of JSYNC, and should not be used at all
unless you know what you are doing.

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2010. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
