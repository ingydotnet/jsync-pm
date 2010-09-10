use TestML -run,
    -require_or_skip => 'JSON',
    -bridge => 't::Bridge';
__DATA__
%TestML 1.0
%PointMarker +++

Title = "Ingy's Test";
Plan = 7;

*jsync.load_jsync.dump_jsync == *jsync.Chomp;

%Include jsync-roundtrip.tml
