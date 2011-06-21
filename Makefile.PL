use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Benchmark::Statistics',
    AUTHOR              => q{Peter Makholm <peter@makholm.net>},
    VERSION_FROM        => 'lib/Benchmark/Statistics.pm',
    ABSTRACT_FROM       => 'lib/Benchmark/Statistics.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Time::HiRes' => 0,
        'Statistics::Descriptive' => 3.0201,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Benchmark-Statistics-*' },
);
