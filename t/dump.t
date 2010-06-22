use TestML -run, -bridge => 't::Bridge';

# filters {
#     yaml => ['load_yaml', 'dump_jsync'],
#     jsync => 'chomp',
#     perl => ['eval', 'dump_jsync'],
#     perl_run => 'eval',
# };

__DATA__
%TestML: 1.0
%Title: Ingy's Test
%Plan: 8
%Data: jsync-yaml.tml
%PointMarker: +++

*yaml.load_yaml().dump_jsync() == *jsync.chomp();
*perl.eval().dump_jsync() == *jsync.chomp();
*perl_run.eval() == *jsync_dump;
