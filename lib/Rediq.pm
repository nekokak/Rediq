package Rediq;
use strict;
use warnings;
our $VERSION = '0.01';
use Redis::hiredis;

sub new {
    my ($class, $opts) = @_;

    my $redis = Redis::hiredis->new();
    $redis->connect($opts->{host}||'127.0.0.1', $opts->{port}||6379);

    bless +{
        redis => $redis,
    }, $class;
}

sub enqueue {
    my ($self, $key, $job) = @_;
    $self->{redis}->command(["RPUSH", $key, $job]);
}

sub dequeue {
    my ($self, $key) = @_;
    $self->{redis}->command(["LPOP", $key]);
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
