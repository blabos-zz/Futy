insert into seasons ( year ) values (2013);

insert into coaches ( name )
values ('Jaime Miler'), ('Matedão'), ('Zenilton de Souza'), ('Sabino Loreti');

insert into clubs ( name, coach )
values ('PINICO FC', 1), ('TRIUNFO EC', 2), ('COHAB', 3), ('MORRO', 4);

insert into positions ( code, name )
values ('GK', 'Goalkeeper'), ('DF', 'Defense'), ('MF', 'Midfield'), ('FW', 'Forward');

insert into players (name,club,pos,number,defense,pass,ability,shoot) values
('Alan',       1, 1,  1, 9, 6, 2, 3),
('Adrian',     1, 2,  2, 6, 6, 4, 4),
('Guilherme',  1, 2,  3, 7, 5, 3, 5),
('Tibirulim',  1, 2,  4, 8, 4, 1, 7),
('Fágner',     1, 2,  6, 5, 6, 6, 3),
('Versim',     1, 3,  5, 5, 4, 6, 5),
('Vágner',     1, 3,  7, 2, 6, 6, 6),
('Afonso',     1, 3,  8, 5, 5, 5, 5),
('Wesley',     1, 3, 10, 4, 8, 3, 5),
('Diego',      1, 4, 11, 2, 6, 4, 8),
('Jucélio',    1, 4,  9, 1, 5, 5, 9),
('Jaílson',    2, 1,  1, 7, 6, 4, 3),
('Crispim',    2, 2,  2, 4, 5, 6, 5),
('Otávio',     2, 2,  3, 7, 6, 5, 2),
('Bruno',      2, 2,  4, 7, 3, 3, 7),
('M. Dutra',   2, 2,  6, 4, 4, 6, 6),
('Tivi',       2, 3,  5, 4, 6, 6, 4),
('M. Pinto',   2, 3,  8, 1, 7, 8, 4),
('Thiago',     2, 3,  7, 5, 5, 5, 5),
('Gabriel',    2, 4, 10, 1, 5, 7, 7),
('Bolinho',    2, 4,  9, 1, 5, 6, 8),
('Júnior',     2, 4, 11, 1, 5, 7, 7),
('Douglas',    3, 1,  1, 8, 5, 4, 3),
('Ivan',       3, 2,  2, 8, 4, 6, 2),
('George',     3, 2,  3, 9, 4, 5, 2),
('Guto',       3, 2,  4, 9, 4, 4, 3),
('Painel',     3, 3,  5, 2, 6, 9, 3),
('Fernando',   3, 3, 25, 2, 8, 5, 5),
('Patrick',    3, 3,  8, 3, 5, 8, 4),
('Marlos',     3, 3, 10, 3, 9, 7, 1),
('Shelton',    3, 4,  7, 1, 5, 8, 6),
('Glauber',    3, 4,  9, 1, 4, 7, 8),
('Beto',       3, 4, 20, 1, 5, 7, 7),
('Adriano',    4, 1, 12, 7, 4, 4, 5),
('Maneco',     4, 2,  2, 8, 3, 4, 5),
('Gugu',       4, 2,  3, 5, 6, 3, 6),
('Eduardo',    4, 2,  4, 9, 5, 3, 3),
('Rafael',     4, 2,  6, 9, 5, 3, 3),
('Leonardo',   4, 3,  8, 1, 8, 9, 2),
('Zezinho',    4, 3, 26, 3, 6, 8, 3),
('Neném',      4, 3, 10, 1, 9, 9, 1),
('Tinga',      4, 3,  7, 3, 8, 6, 3),
('Filipe',     4, 3, 11, 3, 6, 6, 5),
('Ricardinho', 4, 4,  9, 1, 1, 9, 9);

insert into standings (season, club) values (1, 1), (1, 2), (1, 3), (1, 4);

insert into matches (week, home, away) values
(1,1,3),
(1,2,4),
(2,1,4),
(2,2,3),
(3,2,1),
(3,4,3),
(4,3,1),
(4,4,2),
(5,4,1),
(5,3,2),
(6,1,2),
(6,3,4);
