#! /usr/bin/perl
use strict;
use warnings;
use Test::More;
use Rediq;

my $rediq = Rediq->new;
my @jobs = qw/nekokak xaicron zigorou hidek myfinder arisawa/;
$rediq->enqueue('queue', $_) for @jobs;

for my $job (@jobs) {
    is +$rediq->dequeue('queue'), $job;
}

done_testing;
