use utf8;

package Futy::Core::Match;

use Moo;
use DDP;

use List::Util qw{ sum0 };

use Const::Fast;
use Encode;

use Futy::Model;
use Futy::Core::Match::State;
use Futy::Core::Match::Utils qw{ :location :teams };

has 'id' => (
    'is'       => 'ro',
    'required' => 1,
);

has 'actions' => (
    'is'      => 'ro',
    'default' => sub {
        return {
            sht => \&do_shoot,
            pss => \&do_pass,
            drb => \&do_drible,
        };
    },
);

has 'act_mod' => (
    'is'      => 'ro',
    'default' => sub {
        return {
            $LOC_GKB => {
                sht => 1,
                pss => 8,
                drb => 1,
            },
            $LOC_DEF => {
                sht => 1,
                pss => 7,
                drb => 2,
            },
            $LOC_MID => {
                sht => 2,
                pss => 5,
                drb => 3,
            },
            $LOC_FWD => {
                sht => 5,
                pss => 3,
                drb => 2,
            },
            $LOC_GKF => {
                sht => 8,
                pss => 1,
                drb => 1,
            },
        };
    },
);

has 'loc_mod' => (
    'is'      => 'ro',
    'default' => sub {
        return {
            $LOC_GKB => {
                $LOC_GKB => 1,
                $LOC_DEF => 6,
                $LOC_MID => 1,
                $LOC_FWD => 1,
                $LOC_GKF => 1,
            },
            $LOC_DEF => {
                $LOC_GKB => 1,
                $LOC_DEF => 2,
                $LOC_MID => 5,
                $LOC_FWD => 1,
                $LOC_GKF => 1,
            },
            $LOC_MID => {
                $LOC_GKB => 1,
                $LOC_DEF => 2,
                $LOC_MID => 3,
                $LOC_FWD => 3,
                $LOC_GKF => 1,
            },
            $LOC_FWD => {
                $LOC_GKB => 1,
                $LOC_DEF => 1,
                $LOC_MID => 2,
                $LOC_FWD => 3,
                $LOC_GKF => 3,
            },
            $LOC_GKF => {
                $LOC_GKB => 1,
                $LOC_DEF => 1,
                $LOC_MID => 1,
                $LOC_FWD => 1,
                $LOC_GKF => 6,
            },
        };
    },
);

const our @MSG_RIGHT_PASS => (
    sub { "$_[0] toca a bola" },
    sub { "$_[1] para $_[2]" },
    sub { "$_[2] recebe de $_[1]" },
    sub { "Bom passe para $_[2]" },
);

const our @MSG_WRONG_PASS => (
    sub { "$_[0] perde a bola" },
    sub { "$_[1] erra o passe" },
    sub { "O $_[0] machuca a bola" },
    sub { "Passe errado do $_[0]" },
    sub { "$_[2] não alcança o passe de $_[1]" },
);

const our @MSG_SHOOT_OUT => (
    sub { "$_[1] arremata pra fora" },
    sub { "$_[1] manda muito longe. O goleiro agradece!" },
    sub { "$_[1] conclui pra fora" },
    sub { "$_[1] arrisca de longe" },
    sub { "$_[1] chuta de muito longe e manda muito perto" },
    sub { "Chute de $_[1]. Tiro de meta" },
    sub { "$_[1] bate pra fora" },
);

const our @MSG_SHOOT_CORNER => (
    sub { "Escanteio" },
    sub { "Escanteio para o $_[0]" },
    sub { "$_[2] manda para escanteio" },
    sub { "Tiro de canto para o $_[0]" },
    sub { "$_[2] espalma e a bola vai pra escanteio" },
);

const our @MSG_SHOOT_DEF => (
    sub { "$_[2] segura firme" },
    sub { "Boa defesa de $_[2]" },
    sub { "$_[2] sai de soco" },
    sub { "Grande defesa de $_[2]" },
    sub { "$_[2] encaixa firme o chute de $_[1]" },
);

const our @MSG_SHOOT_GOAL => (
    sub { "$_[1] marca um golaço para o $_[0]" },
    sub { "Gol de $_[1] para o $_[0]" },
    sub { "$_[1] toca na saída de $_[2] e marca para o $_[0]" },
    sub { "$_[1] por cobertura... Golaço" },
    sub { "$_[1] manda uma bomba e marca pro $_[0]" },
    sub { "Chute com estilo de $_[1] e gol" },
    sub { "$_[1] do meio da rua... É gol" },
    sub { "$_[1] anota mais um" },
);

const our @MSG_DRIBLE => (
    sub { "O $_[0] prende a bola" },
    sub { "$_[1] dribla $_[2]" },
    sub { "$_[1] entre as pernas de $_[2]" },
    sub { "$_[2] toma um elástico de $_[1]" },
    sub { "Lindo drible de $_[1]" },
    sub { "Chapéu de $_[1] em $_[2]" },
    sub { "$_[1] passa por $_[2]" },
    sub { "$_[1] deixa $_[2] no chão" },
);

const our @MSG_DRIBLE_FAIL => (
    sub { "$_[1] perde a bola" },
    sub { "Bom desarme de $_[2]" },
    sub { "$_[2] recupera a bola" },
    sub { "$_[1] prende demais e $_[2] recupera" },
);

const our @MSG_PENALTY_CORNER => (
    sub { "$_[2] defende e manda pra escanteio" },
    sub { "$_[2] espalma e manda pra fora" },
);

const our @MSG_PENALTY_GOAL => (
    sub { "Gol. Bola de um lado, goleiro do outro" },
    sub { "Batida firme no centro do gol" },
    sub { "$_[2] quase pega mas é gol do $_[0]" },
);

const our @MSG_PENALTY_DEF => (
    sub { "$_[2] defende" },
    sub { "$_[2] acertou o canto e defendeu" },
    sub { "$_[2], espetacular defesa" },
);

sub run {
    my ($self) = @_;

    my $rs    = Futy::Model->schema->resultset('Match');
    my $match = $rs->find( $self->id );

    my $state = Futy::Core::Match::State->new( $match->home, $match->away );

    print $/ . $match->home->name . ' X ' . $match->away->name . $/ . $/;

    $self->play($state);
}

sub play {
    my ( $self, $state ) = @_;

    my $starter = $state->ball->owner;

    while ( $state->timer->time < 45 ) {
        $state->timer->inc;
        $state = $self->do_action($state);
    }

    print 'Intervalo' . $/;

    $state->ball->location($LOC_MID);
    $state->ball->owner( reverse_team($starter) );

    ## Second half
    while ( $state->timer->time < 90 ) {
        $state->timer->inc;
        $state = $self->do_action($state);
    }

    $self->update_standings($state);
}

sub do_action {
    my ( $self, $state ) = @_;

    sleep 1;

    my $time    = $state->timer->time;
    my $loc     = $state->ball->location;
    my $owner   = $state->ball->owner;
    my $what    = $self->what($state);
    my $where   = $self->where($state);
    my $actions = $self->actions;

    print $state->teams->{$TEAM_HOME}->name . ' '
      . $state->score->{$TEAM_HOME} . ' X '
      . $state->score->{$TEAM_AWAY} . ' '
      . $state->teams->{$TEAM_AWAY}->name . ' '
      . $time . ': ';

    return $actions->{$what}->( $state, $where );
}

sub what {
    my ( $self, $state ) = @_;

    my $loc   = $state->ball->location;
    my $owner = $state->ball->owner;

    my $team  = $state->teams->{$owner};
    my $atts  = $self->atts( $team, $loc );
    my $stats = $self->stats( $atts, $loc );

    my $what;
    my $rand = int rand( $stats->{total} );
    foreach my $act (qw{ drb sht pss }) {
        $what = $act;
        $rand -= $stats->{$act};
        last if $rand < 0;
    }

    return $what;
}

sub where {
    my ( $self, $state ) = @_;

    my $where;
    my $rand = int rand(10);
    foreach my $loc (@LOCATIONS) {
        $where = $loc;
        $rand -= $self->loc_mod->{ $state->ball->location }{$loc};
        last if $rand < 0;
    }

    return $where;
}

sub atts {
    my ( $self, $team, $loc ) = @_;

    my @players = grep { $_->pos->id == $loc } $team->players;

    return {
        defense => sum0( map { $_->defense } @players ),
        pass    => sum0( map { $_->pass } @players ),
        ability => sum0( map { $_->ability } @players ),
        shoot   => sum0( map { $_->shoot } @players ),
    };
}

sub stats {
    my ( $self, $atts, $loc ) = @_;

    my $stats = {
        sht => $atts->{shoot} * $self->act_mod->{$loc}{sht},
        pss => $atts->{pass} * $self->act_mod->{$loc}{pss},
        drb => $atts->{ability} * $self->act_mod->{$loc}{drb},
    };

    $stats->{total} = sum0( values %{$stats} );

    return $stats;
}

sub do_shoot {
    my ($state) = @_;

    my $loc = $state->ball->location;
    my $out = {
        $LOC_GKB => 99,
        $LOC_DEF => 95,
        $LOC_MID => 80,
        $LOC_FWD => 50,
        $LOC_GKF => 20,
    };

    my $player = $state->get_player;
    my $team   = $state->teams->{ $state->ball->owner };

    my $rand = int rand(100);

    if ( $rand < $out->{$loc} ) {
        print_shoot_out( $team->name, $player->name );

        $state->ball->location($LOC_GKB);
        $state->ball->toggle_owner;
    }
    else {
        my $goalkeeper = $state->goalkeeper;
        my $corner     = 10 - $goalkeeper->defense;
        my $goal       = $corner + $player->shoot;

        $rand = int rand(20);
        if ( $rand < $corner ) {
            print_shoot_corner( $team->name, $player->name,
                $goalkeeper->name );

            $state->ball->location($LOC_GKF);
        }
        elsif ( $rand < $goal ) {
            $player->goals( $player->goals + 1 );
            $player->update;

            print_shoot_goal( $team->name, $player->name, $goalkeeper->name );

            $state->score_inc( $state->ball->owner );
            $state->ball->location($LOC_MID);
            $state->ball->toggle_owner;
        }
        else {
            print_shoot_corner( $team->name, $player->name,
                $goalkeeper->name );

            $state->ball->location($LOC_GKB);
            $state->ball->toggle_owner;
        }
    }

    return $state;
}

sub do_pass {
    my ( $state, $where ) = @_;

    my $player = $state->act_player;
    my $team   = $state->teams->{ $state->ball->owner };
    my $to     = $state->get_player( $where, $player->name );

    my $error = 10 - $player->pass;

    my $rand = int rand(10);
    if ( $rand < $error ) {
        print_wrong_pass( $team->name, $player->name, $to->name );

        $state->ball->toggle_owner;
        $state->ball->location( reverse_location($where) );
    }
    else {
        print_right_pass( $team->name, $player->name, $to->name );

        $state->ball->location($where);
    }

    return $state;
}

sub do_drible {
    my ( $state, $where ) = @_;

    my $team     = $state->teams->{ $state->ball->owner };
    my $player   = $state->act_player;
    my $defender = $state->def_player($where);

    my $foul   = 10 - $defender->defense;
    my $sucess = $foul + $player->ability;

    my $rand = int rand(10);
    if ( $rand < $foul ) {
        $state = do_foul($state);
    }
    elsif ( $rand < $sucess ) {
        print_drible( $team->name, $player->name, $defender->name );

        $state->ball->location($where);
    }
    else {
        print_drible_fail( $team->name, $player->name, $defender->name );

        $state->ball->toggle_owner;
        $state->ball->location( reverse_location($where) );
    }

    return $state;
}

sub do_foul {
    my ($state) = @_;

    my $loc   = $state->ball->location;
    my $owner = $state->ball->owner;
    my $team  = $state->teams->{$owner};

    print_msg( 'Falta para o ' . $team->name . '. ' );

    if ( $loc >= $LOC_GKF ) {
        $state = do_penalty($state);
    }
    elsif ( $loc >= $LOC_FWD ) {
        $state = do_shoot($state);
    }
    else {
        print_msg('Cobrança rápida. ');
        $state = do_pass( $state, $loc );
    }

    return $state;
}

sub do_penalty {
    my ($state) = @_;

    my $owner      = $state->ball->owner;
    my $player     = $state->get_player;
    my $team       = $state->teams->{$owner};
    my $goalkeeper = $state->goalkeeper;

    print_msg('Dentro da área é Penalty... ');
    print_msg( $player->name . ' na cobrança... ' );

    my $corner = 10 - $goalkeeper->defense;
    my $goal   = $corner + $player->shoot;

    my $rand = int rand(20);
    if ( $rand < $corner ) {
        print_penalty_corner( $team->name, $player->name, $goalkeeper->name );

        $state->ball->location($LOC_GKF);
    }
    elsif ( $rand < $goal ) {
        $player->goals( $player->goals + 1 );
        $player->update;

        print_penalty_goal( $team->name, $player->name, $goalkeeper->name );

        $state->score_inc( $state->ball->owner );
        $state->ball->location($LOC_MID);
        $state->ball->toggle_owner;
    }
    else {
        print_penalty_def( $team->name, $player->name, $goalkeeper->name );

        $state->ball->location($LOC_GKB);
        $state->ball->toggle_owner;
    }

    return $state;
}

sub print_right_pass {
    my $code = $MSG_RIGHT_PASS[ int rand @MSG_RIGHT_PASS ];
    print_msg( $code->(@_) . $/ );
}

sub print_wrong_pass {
    my $code = $MSG_WRONG_PASS[ int rand @MSG_WRONG_PASS ];
    print_msg( $code->(@_) . $/ );
}

sub print_shoot_out {
    my $code = $MSG_SHOOT_OUT[ int rand @MSG_SHOOT_OUT ];
    print_msg( $code->(@_) . $/ );
}

sub print_shoot_corner {
    my $code = $MSG_SHOOT_CORNER[ int rand @MSG_SHOOT_CORNER ];
    print_msg( $code->(@_) . $/ );
}

sub print_shoot_def {
    my $code = $MSG_SHOOT_DEF[ int rand @MSG_SHOOT_DEF ];
    print_msg( $code->(@_) . $/ );
}

sub print_shoot_goal {
    my $code = $MSG_SHOOT_GOAL[ int rand @MSG_SHOOT_GOAL ];
    print_msg( $code->(@_) . $/ );
}

sub print_drible {
    my $code = $MSG_DRIBLE[ int rand @MSG_DRIBLE ];
    print_msg( $code->(@_) . $/ );
}

sub print_drible_fail {
    my $code = $MSG_DRIBLE_FAIL[ int rand @MSG_DRIBLE_FAIL ];
    print_msg( $code->(@_) . $/ );
}

sub print_penalty_corner {
    my $code = $MSG_PENALTY_CORNER[ int rand @MSG_PENALTY_CORNER ];
    print_msg( $code->(@_) . $/ );
}

sub print_penalty_goal {
    my $code = $MSG_PENALTY_GOAL[ int rand @MSG_PENALTY_GOAL ];
    print_msg( $code->(@_) . $/ );
}

sub print_penalty_def {
    my $code = $MSG_PENALTY_DEF[ int rand @MSG_PENALTY_DEF ];
    print_msg( $code->(@_) . $/ );
}

sub print_msg {
    my ($msg) = @_;

    print Encode::encode_utf8($msg);
}

sub update_standings {
    my ( $self, $state ) = @_;

    my $home = Futy::Model->schema->resultset('Standing')
      ->find( $state->teams->{$TEAM_HOME}->id );

    my $away = Futy::Model->schema->resultset('Standing')
      ->find( $state->teams->{$TEAM_AWAY}->id );

    $home->matches( $home->matches + 1 );
    $home->gf( $home->gf + $state->score->{$TEAM_HOME} );
    $home->ga( $home->ga + $state->score->{$TEAM_AWAY} );
    $home->gd( $home->gd +
          $state->score->{$TEAM_HOME} - $state->score->{$TEAM_AWAY} );

    $away->matches( $away->matches + 1 );
    $away->gf( $away->gf + $state->score->{$TEAM_AWAY} );
    $away->ga( $away->ga + $state->score->{$TEAM_HOME} );
    $away->gd( $away->gd +
          $state->score->{$TEAM_AWAY} - $state->score->{$TEAM_HOME} );

    if ( $state->score->{$TEAM_HOME} == $state->score->{$TEAM_AWAY} ) {
        $home->pts( $home->pts + 1 );
        $away->pts( $away->pts + 1 );

        $home->draws( $home->draws + 1 );
        $away->draws( $away->draws + 1 );
    }
    elsif ( $state->score->{$TEAM_HOME} > $state->score->{$TEAM_AWAY} ) {
        $home->pts( $home->pts + 3 );

        $home->wins( $home->wins + 1 );
        $away->losses( $away->losses + 1 );
    }
    else {
        $away->pts( $away->pts + 3 );

        $home->losses( $home->losses + 1 );
        $away->wins( $away->wins + 1 );
    }

    $home->update;
    $away->update;
}

1;

# ABSTRACT: Futy::Core::Match

=encoding utf8

=cut
