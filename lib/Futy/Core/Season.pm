use utf8;

package Futy::Core::Season;

use Moo;

use Futy::Model;
use Futy::Core::Round;

use Const::Fast;
use Encode;

const my $MENU_REPEAT    => '0';
const my $MENU_STANDINGS => '1';
const my $MENU_SCORERS   => '2';
const my $MENU_MATCH     => '9';

const my $OPTIONS => {
    $MENU_STANDINGS => \&print_standings,
    $MENU_SCORERS   => \&print_scorers,
};

has 'id' => (
    'is'       => 'ro',
    'required' => 1,
);

sub run {
    my ($self) = @_;

    my $season = Futy::Model->schema->resultset('Season')->find( $self->id );

    return unless $season;

    foreach my $week ( 1 .. $season->weeks ) {
        pre_match('Pre-Jogo');

        my $round = Futy::Core::Round->new(
            season => $self->id,
            week   => $week,
        );

        $round->run;
    }

    pre_match('Resultados');
}

sub pre_match {
    my ($msg) = @_;

    my $option = $MENU_REPEAT;

    while ( $option ne $MENU_MATCH ) {
        print $msg . $/;
        print_menu();
        $option = <>;
        chomp($option);

        $option = $MENU_REPEAT
          unless $option;

        $OPTIONS->{$option}->()
          if exists $OPTIONS->{$option};
    }
}

sub print_menu {
    print '1 - Ver tabela do campeonato' . $/;
    print '2 - Artilheiros do campeonato' . $/;
    print '9 - Iniciar rodada' . $/;
    print Encode::encode_utf8('Sua opção: ');
}

sub print_standings {
    my $standing = Futy::Model->schema->resultset('Standing')->search(
        {},
        {
            'order_by' => {
                '-desc' => [qw{ pts gd gf }],
            }
        }
    );

    print 'Tabela:' . $/;

    my ( $fmt, @vals );

    _print_std_tb_line();
    _print_std_tb_header();
    _print_std_tb_line();

    foreach my $pos ( 1 .. $standing->count ) {
        _print_std_tb_row( $pos, $standing->next );
    }

    _print_std_tb_line();
}

sub print_scorers {
    my $scorers = Futy::Model->schema->resultset('Player')->search(
        {},
        {
            'order_by' => {
                '-desc' => [qw{ goals pos }],
            },
            'page' => 1,
            'rows' => 5,
        },
    );

    print 'Artilheiros:' . $/;

    my ( $fmt, @vals );

    _print_scr_tb_line();
    _print_scr_tb_header();
    _print_scr_tb_line();

    foreach my $pos ( 1 .. $scorers->count ) {
        _print_scr_tb_row( $pos, $scorers->next );
    }

    _print_scr_tb_line();
}

sub _print_std_tb_line {
    my $fmt  = "+%5s+%22s+%5s+%5s+%5s+%5s+%5s+%5s+%5s+\n";
    my @vals = (
        '-' x 5, '-' x 22, '-' x 5, '-' x 5, '-' x 5, '-' x 5,
        '-' x 5, '-' x 5,  '-' x 5,
    );
    print sprintf( $fmt, @vals );
}

sub _print_std_tb_header {
    my $fmt  = "| %3s | %-20s | %3s | %3s | %3s | %3s | %3s | %3s | %3s |\n";
    my @vals = qw{ POS TIME PTS V E D GP GC SG };
    print sprintf( $fmt, @vals );
}

sub _print_std_tb_row {
    my ( $pos, $row ) = @_;
    my $fmt = "| %3d | %-20s | %3d | %3d | %3d | %3d | %3d | %3d | %3d |\n";
    print sprintf( $fmt,
        $pos,       $row->club->name, $row->pts,
        $row->wins, $row->draws,      $row->losses,
        $row->gf,   $row->ga,         $row->gd );
}

sub _print_scr_tb_line {
    my $fmt = "+%5s+%22s+%22s+%6s+\n";
    my @vals = ( '-' x 5, '-' x 22, '-' x 22, '-' x 6, );
    print sprintf( $fmt, @vals );
}

sub _print_scr_tb_header {
    my $fmt  = "| %3s | %-20s | %-20s | %4s |\n";
    my @vals = qw{ POS JOGADOR TIME GOLS };
    print sprintf( $fmt, @vals );
}

sub _print_scr_tb_row {
    my ( $pos, $row ) = @_;
    my $fmt = "| %3d | %-20s | %-20s | %4d |\n";
    print Encode::encode_utf8(
        sprintf( $fmt, $pos, $row->name, $row->club->name, $row->goals ) );
}

1;

# ABSTRACT: Futy::Core::Season

=encoding utf8

=cut
