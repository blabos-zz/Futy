use utf8;

package Futy::Core::Match::Utils;

use Moo;
extends 'Exporter';

use Const::Fast;

const our $LOC_GKB => 1;
const our $LOC_DEF => 2;
const our $LOC_MID => 3;
const our $LOC_FWD => 4;
const our $LOC_GKF => 5;

const our @LOCATIONS => (
    $LOC_GKB,    ##
    $LOC_DEF,    ##
    $LOC_MID,    ##
    $LOC_FWD,    ##
    $LOC_GKF,    ##
);

const our $TEAM_HOME => 1;
const our $TEAM_AWAY => 2;

our @EXPORT_OK = qw{
  $LOC_GKB
  $LOC_DEF
  $LOC_MID
  $LOC_FWD
  $LOC_GKF
  @LOCATIONS
  reverse_location

  $TEAM_HOME
  $TEAM_AWAY
  reverse_team
};

our %EXPORT_TAGS = (
    'location' => [
        qw{
          $LOC_GKB
          $LOC_DEF
          $LOC_MID
          $LOC_FWD
          $LOC_GKF
          @LOCATIONS
          reverse_location
          }
    ],
    'teams' => [
        qw{
          $TEAM_HOME
          $TEAM_AWAY
          reverse_team
          }
    ],
);

sub reverse_location { $LOCATIONS[ 0 - shift ] }

sub reverse_team { shift == $TEAM_HOME ? $TEAM_AWAY : $TEAM_HOME }

1;

# ABSTRACT: Futy::Core::Match::Utils

=encoding utf8

=cut
