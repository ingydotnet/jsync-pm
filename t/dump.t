use TestML -run, -bridge => 't::Bridge';

__DATA__
%TestML: 1.0
%Data: jsync-yaml.tml
%PointMarker: +++

Title = "Ingy's Test";
Plan = 9;

*yaml.load_yaml().dump_jsync() == *jsync.chomp();

*perl.eval().dump_jsync() == *jsync.chomp();

*perl_run.eval() == *jsync;
