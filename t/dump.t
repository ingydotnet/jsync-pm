use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML::XS',
    -bridge => 't::Bridge';

__DATA__
%TestML 1.0
%PointMarker +++

Title = "Ingy's Test";
Plan = 9;

*yaml.load_yaml.dump_jsync == *jsync.Chomp;

*perl.eval.dump_jsync == *jsync.Chomp;

*perl_run.eval == *jsync;

%Include jsync-yaml.tml
