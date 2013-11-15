use utf8;

package Futy::Core::Match::Timer;

use Moo;

has 'time' => (
    'is'      => 'ro',
    'default' => sub { 0 },
);

sub inc {
    my ($self) = @_;

    return ++$self->{'time'};
}

1;

# ABSTRACT: Futy::Core::Match::Timer

=encoding utf8

=cut
