package Benchmark::Statistics;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use Time::HiRes qw(gettimeofday tv_interval);
use Statistics::Descriptive;

use Exporter;

our(@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS,);
@ISA=qw(Exporter);
@EXPORT=qw();
@EXPORT_OK=qw(timeit timethis);
%EXPORT_TAGS=( all => [ @EXPORT, @EXPORT_OK ] ) ;


=head1 NAME

Benchmark::Statistics - basic statistics from benchmarking Perl code

=head1 SYNOPSIS

    us Benchmark::Statistics qw(:all)

    # Get statistics object
    my $stat = timeit($count, $code);

    # ... or just print some statiostics directly
    timethis($count, $code);

=head1 DESCRIPTION

This module encapsulates some routines to help you banchmark and create
simple statistics for executing some code. 

This module is not suited for micro-benchmarks where the runtime is expected
to be short and where the variance is expected to be negligible. For this 
L<Benchmark> is a better choice.

=head1 Standard Exports

=head2 timeit(COUNT, CODE)

Arguments: COUNT is the number of times to run the loop, and CODE is
the code the run. The COUNT can be zero or negative: this means the
I<minimum number of wallclock seconds> to run. A zero signifies the
default of 3 seconds. The CODE should be a code reference.

Returns: a Statistics::Descriptive::Full object

=cut

sub timeit {
    my ($n, $code) = @_;

    my @results;
    if ( $n <= 0 ) {
        $n = $n == 0 ? 3 : -$n;
        
        while ( $n > 0 ) {
            my $t0 = [gettimeofday];
            $code->();
            push @results, tv_interval( $t0 );
            $n -= $results[-1];
        }

    } else {
        while ( $n > 0 ) {
            my $t0 = [gettimeofday];
            $code->();
            push @results, tv_interval( $t0 );

            $n--;
        }
    }

    my $stat = Statistics::Descriptive::Full->new();
    $stat->add_data( @results );

    return $stat;
}


=head2 timethis(COUNT, CODE) 

Times the code as C<timeit> but prints the result to STDOUT

=cut

sub timethis {
    my $stat = timeit( @_ );

    print "Count:           " . $stat->count() . "\n";
    print "Average:         " . $stat->mean()  . "\n";
    print "\n";
    print "Minimum:         " . $stat->quantile(0) . "\n";
    print "First quartile:  " . $stat->quantile(1) . "\n";
    print "Median:          " . $stat->quantile(2) . "\n";
    print "Third quartile:  " . $stat->quantile(3) . "\n";
    print "Maximum:         " . $stat->quantile(4) . "\n";
    print "\n";

    my $k = 1.5*( $stat->quantile(3) - $stat->quantile(1) );
    my @bounds = ( $stat->quantile(1) - $k, $stat->quantile(3) + $k);
    print "Lower outliers:  " . join(", ", grep { $_ < $bounds[0] } $stat->get_data()) . "\n";
    print "Upper outliers:  " . join(", ", grep { $_ > $bounds[1] } $stat->get_data()) . "\n";

    return $stat;
}

=head1 SEE ALSO

L<Statistics::Descriptive> - basic descriptive statistical functions used

L<Benchmark> - the real Benchmarking module

=head1 AUTHOR

Peter Makholm, C<< <peter at makholm.net> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Peter Makholm.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Benchmark::Statistics
