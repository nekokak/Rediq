package Rediq;
use strict;
use warnings;
our $VERSION = '0.01';
use RedisDB;

sub new {
    my ($class, $opts) = @_;

    my $redis = RedisDB->new(
        host => ($opts->{host}||'localhost'),
        port => ($opts->{port}||6379)
    );
    bless +{
        redis => $redis,
    }, $class;
}

sub redis { $_[0]->{redis} }

sub enqueue {
    my ($self, $key, $job) = @_;
    $self->redis->rpush($key, $job);
}

sub dequeue {
    my ($self, $key, $limit) = @_;

    my $range = $limit ? $limit - 1 : -1;
    my $redis = $self->redis;
    $redis->multi;
    $redis->lrange($key, 0, $range);
    my $res = $redis->exec;

    if (my $tasks = $res->[0]) {
        return Rediq::Task->new($self, $key, $tasks);
    }
    else {
        return;
    }
}

sub queue_end {
    my ($self, $key, $len) = @_;
    $self->redis->ltrim($key, $len, -1);
}

package 
  Rediq::Task;

sub new {
    my ($class, $klass, $key, $tasks) = @_;
    bless +{
        klass => $klass,
        key   => $key,
        tasks => $tasks,
        len   => scalar(@{$tasks}),
    }, $class;
}

sub end {
    my $self = shift;
    $self->{klass}->queue_end($self->{key}, $self->{len});
}

1;
__END__

=head1 NAME

Rediq -

=head1 SYNOPSIS

  use Rediq;

=head1 DESCRIPTION

Rediq is

=head1 AUTHOR

Atsushi Kobayashi E<lt>nekokak _at_ gmail _dot_ comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
