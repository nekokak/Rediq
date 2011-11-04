#! /usr/bin/perl
use strict;
use warnings;
use Test::More;
use Rediq;

my $rediq = Rediq->new;
$rediq->redis->del('queue');

my @jobs = qw/nekokak xaicron zigorou hidek myfinder arisawa/;

my $tasks;

subtest 'dequeue' => sub {
    $rediq->enqueue('queue', $_) for @jobs;

    $tasks = $rediq->dequeue('queue', 2);
    ok $tasks;
    $tasks->end();

    $tasks = $rediq->dequeue('queue', 2);
    ok $tasks;
    $tasks->end();

    $tasks = $rediq->dequeue('queue', 2);
    ok $tasks;
    $tasks->end();

    $tasks = $rediq->dequeue('queue', 2);
    ok not $tasks;

    $rediq->redis->del('queue');
};

subtest 'dequeue all' => sub {
    $rediq->enqueue('queue', $_) for @jobs;

    $tasks = $rediq->dequeue('queue');
    ok $tasks;
    $tasks->end();

    $rediq->enqueue('queue', $_) for @jobs;
    $tasks = $rediq->dequeue('queue');
    ok $tasks;
    $tasks->end();

    $rediq->enqueue('queue', $_) for @jobs;
    $tasks = $rediq->dequeue('queue');
    ok $tasks;
    $tasks->end();

    $rediq->enqueue('queue', $_) for @jobs;
    $tasks = $rediq->dequeue('queue');
    ok $tasks;

    $rediq->redis->del('queue');
};

$rediq->redis->del('queue');

done_testing;
