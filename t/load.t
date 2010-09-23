use TestML -run,
    -require_or_skip => 'JSON',
    -require_or_skip => 'YAML::XS',
    -bridge => 't::Bridge',
    -testml => 'testml/load.tml';
