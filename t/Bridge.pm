package t::Bridge;
use TestML::Bridge -base;
use JSYNC;
use YAML::XS;

sub load_jsync {
    my ($self) = @_;
    return JSYNC::load($self->value);
}

sub dump_jsync {
    my ($self) = @_;
    return JSYNC::dump($self->value);
}

sub load_yaml {
    my ($self) = @_;
    return YAML::XS::Load($self->value);
}

sub dump_yaml {
    my ($self) = @_;
    return YAML::XS::Dump($self->value);
}

sub chomp {
    my ($self) = @_;
    my $str = $self->value;
    chomp($str);
    return $str;
}

sub eval {
    my ($self) = @_;
    return eval($self->value);
}

1;
