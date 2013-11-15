use utf8;
use strict;
use warnings;

package Futy::Schema::Result::Coach;

use base 'DBIx::Class::Core';

__PACKAGE__->table('coaches');

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
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    'clubs',
    'Futy::Schema::Result::Club',
    { 'foreign.coach' => 'self.id' },
    {
        cascade_copy   => 0,
        cascade_delete => 0,
    },
);

1;

# ABSTRACT: Futy::Schema::Result::Coach

=encoding utf8

=cut
