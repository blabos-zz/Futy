requires 'DBIx::Class'                 => '== 0.08250';
requires 'DBIx::Class::Schema::Loader' => '== 0.07036';
requires 'Const::Fast'                 => '== 0.014';
requires 'DateTime::Format::SQLite'    => '== 0.11';
requires 'Moo'                         => '== 1.003001';
requires 'JSON'                        => '== 2.59';
requires 'JSON::XS'                    => '== 2.34';
requires 'RedisDB'                     => '== 2.17';
requires 'Try::Tiny'                   => '== 0.18';
requires 'Mojolicious'                 => '== 4.48';

requires 'perl' => '>= 5.014';

on 'test' => sub {
    requires 'Test::Most'      => '0.31';
    requires 'SQL::Translator' => '>= 0.11016';
};

on 'configure' => sub {
    requires 'ExtUtils::MakeMaker' => '6.30';
};

on 'develop' => sub {
    requires 'Pod::Coverage::TrustPod' => '0';
    requires 'Test::Pod'               => '1.41';
    requires 'Test::Pod::Coverage'     => '1.08';
};
