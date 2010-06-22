use TestML -run, -bridge => 't::Bridge';

__DATA__
%TestML: 1.0
%Title: Ingy's Test
%Plan: 6
%Data: jsync-yaml.tml
%PointMarker: +++

*jsync.load_jsync().dump_yaml() == *yaml;

