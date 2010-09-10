use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML::XS',
    -bridge => 't::Bridge';

__DATA__
%TestML 1.0
%PointMarker +++

Title = "Ingy's Test";
Plan = 7;

*jsync.load_jsync.dump_yaml == *yaml;

%Include jsync-yaml.tml
