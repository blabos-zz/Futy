use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Season;

use base 'DBIx::Class::Core';

__PACKAGE__->table('seasons');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'year' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'weeks' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint( 'year_unique', ['year'] );

__PACKAGE__->has_many(
    'matches',
    'Futy::Schema::Result::Match',
    { 'foreign.season' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,

    },
);

__PACKAGE__->has_many(
    'standings',
    'Futy::Schema::Result::Standing',
    { 'foreign.season' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

1;

# ABSTRACT: Futy::Schema::Result::Season

=encoding utf8

=cut
