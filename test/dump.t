use File::Basename;
use lib dirname(__FILE__), 'inc';

{
    use Test::More;
    eval "use YAML::XS; 1" or plan skip_all => 'YAML::XS required';
}

use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/dump.tml',
    bridge => 'TestMLBridge',
)->run;
