/* Create videogame table with gameid */
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
Title,ReleaseDate,
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

/* Create splitted table for genre */
CREATE TABLE split_g AS
SELECT gameid, Genres,
       trim(value) AS split_genre
FROM videogame,
json_each('["' || replace(Genres, ',', '","') || '"]')
WHERE split_genre <> '';
UPDATE split_g SET split_genre = REPLACE
(REPLACE(REPLACE(split_genre, '[', ''), ']', ''), "'", '');

/* Create splitted table for team */
CREATE TABLE split_t AS
SELECT gameid, Team,
       trim(value) AS split_team
FROM videogame,
json_each('["' || replace(Team, ',', '","') || '"]')
WHERE split_team <> '';
UPDATE split_t SET split_team= REPLACE
(REPLACE(REPLACE(split_team, '[', ''), ']', ''), "'", '');
/* Create the splitted table for Reviews */
CREATE TABLE rev AS
WITH recursive splits AS (
  SELECT
	gameid,
    substr(Reviews, 1, instr(Reviews, "',") - 1) AS split_review,
    substr(Reviews, instr(Reviews, "',") + 3) AS remaining_reviews
  FROM videogame

  UNION ALL

  SELECT
	gameid,
    substr(remaining_reviews, 1, instr(remaining_reviews, "',") - 1),
    substr(remaining_reviews, instr(remaining_reviews, "',") + 3)
  FROM splits
  WHERE remaining_reviews <> ''
)
SELECT gameid, split_review
FROM splits;

/* Removing the empty values and the single quotes */
DELETE FROM rev
WHERE split_review IS NULL OR split_review = '';

UPDATE rev SET split_review = REPLACE
(REPLACE(REPLACE(split_review, '[', ''), ']', ''), "'", '');

/* Create the teams table */
CREATE TABLE teams (
teamid  INTEGER  PRIMARY KEY AUTOINCREMENT,
team_name);
INSERT INTO teams (
team_name)
SELECT DISTINCT split_team
FROM split_t;

/* Create the genre table */
CREATE TABLE genre (
genreid  INTEGER  PRIMARY KEY AUTOINCREMENT,
genre_name);
INSERT INTO genre (
genre_name)
SELECT DISTINCT split_genre
FROM split_g;

/* Create the review table */
CREATE TABLE review (
reviewid INTEGER PRIMARY KEY AUTOINCREMENT,
review_name);
INSERT INTO review (review_name)
SELECT split_review FROM rev;

/* Create joining table for the imported table and the splitted genre table */
CREATE TABLE split AS
SELECT * FROM videogame
JOIN split_g ON
split_g.gameid = videogame.gameid;

/* Create new table removing the redundent column from split table */
CREATE TABLE split1 AS
SELECT gameid, title, ReleaseDate, Team,
Rating, TimesListed, NumberofReviews, split_genre,
Summary, Reviews, Plays, Playing, Backlogs,
Wishlist
FROM split;

/* Create new combinging split1 and the splitted team table */
CREATE TABLE split2 AS
SELECT * FROM split1
JOIN split_t ON split_t.gameid = split1.gameid;

/* Create new table joining the splitted reviews table and the split2 table */
CREATE TABLE game_split AS
SELECT * FROM split2
JOIN rev ON rev.gameid = split2.gameid;

/* Create new 1nf table */
CREATE TABLE game_1nf AS
SELECT gameid, Title,
ReleaseDate, split_team,
Rating, TimesListed, NumberofReviews,
split_genre, Summary,
split_review, Plays, Playing,
Backlogs, Wishlist
FROM game_split;
