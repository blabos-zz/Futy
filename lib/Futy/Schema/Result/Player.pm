use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Player;

use base 'DBIx::Class::Core';

__PACKAGE__->table('players');

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
    'pos' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'number' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'defense' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'pass' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'ability' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'shoot' => {
        data_type   => 'integer',
        is_nullable => 0,

    },
    'club' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'goals' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'yellow_cards' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,

    },
    'red_cards' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(
    'club_number_unique',
    [ 'club', 'number' ],
);

__PACKAGE__->belongs_to(
    'club',
    'Futy::Schema::Result::Club',
    { id => 'club' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

__PACKAGE__->belongs_to(
    'pos',
    'Futy::Schema::Result::Position',
    { id => 'pos' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

1;
