use utf8;

package Futy::Model;

use Futy::Schema;

use FindBin;

my $__dbname = "$FindBin::Bin/../var/futy.sqlite";
my $__dsn    = "dbi:SQLite:dbname=$__dbname;sqlite_unicode=1";
my $__schema = undef;

sub import {
    $__schema = Futy::Schema->connect($__dsn)
      unless $__schema;
}

sub schema { return $__schema }

1;

# ABSTRACT: Futy::Model

=encoding utf8

=cut
