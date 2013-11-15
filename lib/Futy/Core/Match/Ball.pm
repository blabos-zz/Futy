use utf8;

package Futy::Core::Match::Ball;

use Moo;

use Futy::Core::Match::Utils qw{ :teams $LOC_MID };

has 'location' => ( 'is' => 'rw' );
has 'owner'    => ( 'is' => 'rw' );

sub BUILD {
    my ($self) = @_;

    $self->location($LOC_MID);
    $self->owner( rand() < 0.5 ? $TEAM_HOME : $TEAM_AWAY );
}

sub toggle_owner {
    my ($self) = @_;

    $self->owner( reverse_team( $self->owner ) );
}

1;

# ABSTRACT: Futy::Core::Match::Ball

=encoding utf8

=cut
