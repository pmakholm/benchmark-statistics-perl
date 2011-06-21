#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Benchmark::Statistics' ) || print "Bail out!\n";
}

diag( "Testing Benchmark::Statistics $Benchmark::Statistics::VERSION, Perl $], $^X" );
