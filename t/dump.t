use t::TestJSYNC tests => 7;

spec_file 't/jsync-yaml.tml';

filters {
    yaml => ['load_yaml', 'dump_jsync'],
    jsync => 'chomp',
    perl => ['eval', 'dump_jsync'],
};

run_is yaml => 'jsync';
run_is perl => 'jsync';
