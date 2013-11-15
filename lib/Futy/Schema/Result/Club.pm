use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Club;

use base 'DBIx::Class::Core';

__PACKAGE__->table('clubs');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'name' => {
        data_type   => 'varchar',
        is_nullable => 0,
    },
    'coach' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'coach',
    'Futy::Schema::Result::Coach',
    { id => 'coach' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

__PACKAGE__->has_many(
    'matches_away',
    'Futy::Schema::Result::Match',
    { 'foreign.away' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

__PACKAGE__->has_many(
    'matches_homes',
    'Futy::Schema::Result::Match',
    { 'foreign.home' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

__PACKAGE__->has_many(
    'players',
    'Futy::Schema::Result::Player',
    { 'foreign.club' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

__PACKAGE__->has_many(
    'standings',
    'Futy::Schema::Result::Standing',
    { 'foreign.club' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

1;

# ABSTRACT: Futy::Schema::Result::Club

=encoding utf8

=cut
