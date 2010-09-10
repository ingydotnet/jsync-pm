package t::Bridge;
use JSYNC;

sub load_jsync {
    return JSYNC::load(shift->value);
}

sub dump_jsync {
    return JSYNC::dump(shift->value);
}

sub load_yaml {
    require YAML::XS;
    return YAML::XS::Load(shift->value);
}

sub dump_yaml {
    require YAML::XS;
    return YAML::XS::Dump(shift->value);
}

sub chomp {
    my $str = shift->value;
    chomp($str);
    return $str;
}

sub eval {
    return eval(shift->value);
}

1;
