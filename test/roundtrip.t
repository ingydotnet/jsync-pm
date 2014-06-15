use File::Basename;
use lib dirname(__FILE__), 'inc';

use TestML;
use TestMLBridge;

TestML->new(
    testml => 'testml/roundtrip.tml',
    bridge => 'TestMLBridge',
)->run;
