use utf8;

package Futy::Core::Game;

use Moo;
use DDP;
use Encode;

use Futy::Model;
use Futy::Core::Season;

sub run {
    my ($self) = @_;

    my $rs_seasons = Futy::Model->schema->resultset('Season');

    foreach my $row ( $rs_seasons->all ) {
        my $game = Futy::Core::Season->new( id => $row->id );
        $game->run;
    }

    my $champion = Futy::Model->schema->resultset('Standing')->search(
        {},
        {
            'order_by' => {
                '-desc' => [qw{ pts gd gf }],
            },
            'rows' => 1,
            'page' => 1,
        }
    )->single;

    print Encode::encode_utf8( 'O '
          . $champion->club->name
          . ' é o campeão de '
          . $champion->season->year
          . $/ );

    print 'Game Over' . $/;
}

1;

# ABSTRACT: Futy::Core::Game

=encoding utf8

=cut
