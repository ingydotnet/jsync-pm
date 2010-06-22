use t::TestJSYNC tests => 8;

spec_file 't/jsync-yaml.tml';

filters {
    yaml => ['load_yaml', 'dump_jsync'],
    jsync => 'chomp',
    perl => ['eval', 'dump_jsync'],
    perl_run => 'eval',
};

run_is yaml => 'jsync';
run_is perl => 'jsync';
run_is perl_run => 'jsync_dump';
