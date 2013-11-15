use utf8;

package Futy::Schema::ResultSet::Match;

use Moo;
extends 'DBIx::Class::ResultSet';

sub matches {
    my ( $self, $season, $week ) = @_;

    my $rs = $self->search(
        {
            season => $season,
            week   => $week,
        },
        {
            'order_by' => 'id',
        },
    );

    return $rs;
}

1;

# ABSTRACT: Futy::Schema::ResultSet::Match

=encoding utf8

=cut
