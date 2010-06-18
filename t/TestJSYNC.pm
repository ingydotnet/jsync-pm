package t::TestJSYNC;
use Test::Base -base;

use JSYNC;
use YAML::XS;

delimiters('===', '+++');


package t::TestJSYNC::Filter;
use base 'Test::Base::Filter';
# use XXX -with => 'Data::Dumper';

sub load_jsync {
    my $self = shift;
    my $jsync = shift;
    return JSYNC::load($jsync);
}

sub dump_jsync {
    my $self = shift;
    my $object = shift;
    local $JSON::KeySort = 1;
    return JSYNC::dump($object);
}

sub load_yaml {
    my $self = shift;
    return YAML::XS::Load(@_);
}

sub dump_yaml {
    my $self = shift;
    return YAML::XS::Dump(@_);
}

1;
