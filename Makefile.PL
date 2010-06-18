use inc::Module::Install;

name            'JSYNC';
all_from        'lib/JSYNC.pm';

requires        'JSON';
test_requires   'YAML::XS';

use_test_base;

WriteAll;
