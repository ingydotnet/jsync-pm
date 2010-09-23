use inc::Module::Install;

name            'JSYNC';
all_from        'lib/JSYNC.pm';
readme_from;
manifest_skip;
ack_xxx;
version_check;

requires        'JSON';
test_requires   'YAML::XS';

use_testml;
testml_setup 't/testml.yaml';

clean_files     'MANIFEST';

WriteAll;
