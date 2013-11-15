use utf8;

package Futy;

use Futy::Core::Game;

sub run { Futy::Core::Game->new->run }

1;

# ABSTRACT: Um simulador de futebol

=encoding utf8

=head1 REQUISITOS DE SISTEMA

=over 4

=item SO Linux

=item Perl 5.18.x ou compilador disponível (para compilar o Perl correto)

=item Carton

=back

=head1 INSTALAÇÃO

=over 4

=item 1 - Verfique a versão do Perl com:
    perl -v

=item 1.1 - Se a versão for anterior à versão 5.18.x, um novo Perl pode ser
instalado seguindo as instruções em L<http://perlbrew.pl>.

=item 1.2 - Instale o C<cpanm> com:
    perlbrew install-cpanm

=item 2 - Instale ou atualize o Carton com:
    cpanm Carton

=item 3 - Descompacte o pacote do Futy, entre no diretório criado e execute o
Carton para instalar as dependências com:
    carton install

=item 4 - Excute o Futy com:
    ./script/futy.pl

=back

=cut
