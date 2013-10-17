use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Match;

use base 'DBIx::Class::Core';

__PACKAGE__->table('matches');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => 'integer',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'week' => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    'home' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'away' => {
        data_type      => 'integer',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    'home_goals' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
    'away_goals' => {
        data_type     => 'integer',
        default_value => 0,
        is_nullable   => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'away',
    'Futy::Schema::Result::Club',
    { id => 'away' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

__PACKAGE__->belongs_to(
    'home',
    'Futy::Schema::Result::Club',
    { id => 'home' },
    {
        is_deferrable => 0,
        on_delete     => 'NO ACTION',
        on_update     => 'NO ACTION',
    },
);

1;
