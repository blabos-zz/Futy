drop table if exists seasons;
create table seasons (
    id          integer primary key autoincrement,
    year        integer unique not null
);

drop table if exists standings;
create table standings (
    id          integer primary key autoincrement,
    season      integer not null,
    club        integer not null,
    matches     integer not null default 0,
    pts         integer not null default 0,
    wins        integer not null default 0,
    draws       integer not null default 0,
    losses      integer not null default 0,
    gf          integer not null default 0,
    ga          integer not null default 0,
    gd          integer not null default 0,
    foreign key ( season ) references seasons ( id ),
    foreign key ( club ) references clubs ( id )
);

drop table if exists matches;
create table matches (
    id          integer primary key autoincrement,
    week        integer not null,
    home        integer not null,
    away        integer not null,
    home_goals  integer not null default 0,
    away_goals  integer not null default 0,
    foreign key ( home ) references clubs ( id ),
    foreign key ( away ) references clubs ( id )
);

drop table if exists coaches;
create table coaches (
    id          integer primary key autoincrement,
    name        varchar not null
);

drop table if exists clubs;
create table clubs (
    id          integer primary key autoincrement,
    name        varchar not null,
    coach       integer not null,
    foreign key ( coach ) references coaches( id )
);

drop table if exists players;
create table players (
    id              integer primary key autoincrement,
    name            varchar not null,
    pos             integer not null,
    number          integer not null,
    defense         integer not null,
    pass            integer not null,
    ability         integer not null,
    shoot           integer not null,
    club            integer not null,
    goals           integer not null default 0,
    yellow_cards    integer not null default 0,
    red_cards       integer not null default 0,
    unique( club, number ),
    foreign key ( pos ) references positions( id ),
    foreign key ( club ) references clubs( id )
);

drop table if exists positions;
create table positions (
    id          integer primary key autoincrement,
    name        varchar not null,
    code        varchar not null
);