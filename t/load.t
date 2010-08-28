use TestML -run, -bridge => 't::Bridge';

__DATA__
%TestML: 1.0
%Data: jsync-yaml.tml
%PointMarker: +++

Title = "Ingy's Test";
Plan = 7;

*jsync.load_jsync().dump_yaml() == *yaml;

