use utf8;

package Futy::Core::Round;

use Moo;

use Futy::Core::Match;

has 'season' => (
    'is'       => 'ro',
    'required' => 1,
);

has 'week' => (
    'is'       => 'ro',
    'required' => 1,
);

sub run {
    my ($self) = @_;

    my $rs = Futy::Model->schema->resultset('Match');

    foreach my $row ( $rs->matches( $self->season, $self->week )->all ) {
        my $match = Futy::Core::Match->new( id => $row->id );
        $match->run;
    }
}

1;

# ABSTRACT: Futy::Core::Round

=encoding utf8

=cut
