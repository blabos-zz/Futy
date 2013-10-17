use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Standing;

use base 'DBIx::Class::Core';

__PACKAGE__->table('standings');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'season' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'club' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'matches' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'pts' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'wins' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'draws' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'losses' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'gf' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'ga' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'gd' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key('id');

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
    'season',
    'Futy::Schema::Result::Season',
    { id => 'season' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

1;
