use utf8;

package Futy::Core::Match::State;

use Moo;

use DDP;

use Futy::Core::Match::Utils qw{ :teams :location };
use Futy::Core::Match::Ball;
use Futy::Core::Match::Timer;

has 'ball' => (
    'is'      => 'ro',
    'default' => sub { Futy::Core::Match::Ball->new }
);

has 'teams' => (
    'is'       => 'ro',
    'required' => 1,
);

has 'score' => (
    'is'       => 'ro',
    'required' => 1,
);

has 'timer' => (
    'is'      => 'ro',
    'default' => sub { Futy::Core::Match::Timer->new }
);

sub BUILDARGS {
    my ( $class, $home, $away ) = @_;

    return {
        'teams' => {
            $TEAM_HOME => $home,
            $TEAM_AWAY => $away,
        },
        'score' => {
            $TEAM_HOME => 0,
            $TEAM_AWAY => 0,
        },
    };
}

sub score_inc {
    my ( $self, $team ) = @_;

    $self->score->{$team}++;
}

sub act_player {
    my ( $self, $loc ) = @_;

    $loc ||= $self->ball->location;
    my $owner = $self->ball->owner;

    $loc = $LOC_FWD if $loc == $LOC_GKF;

    my @players =
      grep { $_->pos->id == $loc } $self->teams->{$owner}->players;

    return $players[ int rand(@players) ];
}

sub get_player {
    my ( $self, $loc, $except ) = @_;

    $loc ||= $self->ball->location;
    my $owner = $self->ball->owner;

    $loc = $LOC_FWD if $loc == $LOC_GKF;

    my @except = $self->teams->{$owner}->players;
    @except = grep { $_->name ne $except } @except
      if $except;

    my @at_loc = grep { $_->pos->id == $loc } @except;
    @at_loc = @except
      unless @at_loc > 0;

    return $at_loc[ int rand @at_loc ];
}

sub def_player {
    my ( $self, $where ) = @_;

    my $loc   = reverse_location($where);
    my $owner = reverse_team( $self->ball->owner );

    $loc = $LOC_FWD if $loc == $LOC_GKF;

    my @players =
      grep { $_->pos->id == $loc } $self->teams->{$owner}->players;

    return $players[ int rand(@players) ];
}

sub goalkeeper {
    my ($self) = @_;

    my $loc   = $LOC_GKB;
    my $owner = reverse_team( $self->ball->owner );
    my @players =
      grep { $_->pos->id == $loc } $self->teams->{$owner}->players;

    return shift @players;
}

1;

# ABSTRACT: Futy::Core::Match::State

=encoding utf8

=cut
