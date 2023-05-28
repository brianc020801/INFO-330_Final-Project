-- create videogame table with videoid --
CREATE TABLE videogame(
gameid INTEGER PRIMARY KEY AUTOINCREMENT,
Title,ReleaseDate,
Team,Rating,
TimesListed,NumberofReviews,
Genres,Summary,
Reviews,Plays,
Playing,Backlogs,
Wishlist);

INSERT INTO videogame(
title,ReleaseDate,
Team,Rating,
TimesListed,NumberofReviews,
Genres,Summary,
Reviews,Plays,
Playing,Backlogs,
Wishlist)
SELECT
title,ReleaseDate,
Team,Rating,
TimesListed,NumberofReviews,
Genres,Summary,
Reviews,Plays,
Playing,Backlogs,
Wishlist FROM game;

-- create 1nf table for genre --
CREATE TABLE split_g AS
SELECT gameid, Genres,
       trim(value) AS split_genre
FROM videogame,
json_each('["' || replace(Genres, ',', '","') || '"]')
WHERE split_genre <> '';
UPDATE split_g SET split_genre = REPLACE
(REPLACE(REPLACE(split_genre, '[', ''), ']', ''), "'", '');

-- create 1nf table for team --
CREATE TABLE split_t AS
SELECT gameid, Team,
       trim(value) AS split_team
FROM videogame,
json_each('["' || replace(Team, ',', '","') || '"]')
WHERE split_team <> '';
UPDATE split_t SET split_team= REPLACE
(REPLACE(REPLACE(split_team, '[', ''), ']', ''), "'", '');

-- create general table --
CREATE TABLE popular_games AS
SELECT gameid, Title,
ReleaseDate, Rating,
TimesListed, NumberofReviews,
Plays, Playing,
Backlogs, Wishlist
FROM videogame;

-- create teams table --
CREATE TABLE teams (
teamid  INTEGER  PRIMARY KEY AUTOINCREMENT,
team_name);
INSERT INTO teams (
team_name)
SELECT DISTINCT split_team
FROM split_t;

-- create genres table --
CREATE TABLE genre (
genreid  INTEGER  PRIMARY KEY AUTOINCREMENT,
genre_name);
INSERT INTO genre (
genre_name)
SELECT DISTINCT split_genre
FROM split_g;

-- create joining table --
CREATE TABLE split AS
SELECT * FROM videogame
JOIN split_g ON
split_g.gameid = videogame.gameid;

-- create new table with split genre
CREATE TABLE split1 AS
SELECT gameid, title, ReleaseDate, Team,
Rating, TimesListed, NumberofReviews, split_genre,
Summary, Reviews, Plays, Playing, Backlogs,
Wishlist
FROM split;

-- create table combinging split1 and split_t
CREATE TABLE game_split AS
SELECT * FROM split1
JOIN split_t ON split_t.gameid = split1.gameid;

-- create new 1nf table
CREATE TABLE game_1nf AS
SELECT gameid, Title,
ReleaseDate, split_team,
Rating, TimesListed, NumberofReviews,
split_genre, Summary,
Reviews, Plays, Playing,
Backlogs, Wishlist
FROM game_split;
-- dropping the unwanted tables
DROP TABLE split_t
DROP TABLE split_g
DROP TABLE split
DROP TABLE split1
DROP TABLE game_split
