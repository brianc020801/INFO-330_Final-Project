CREATE TABLE IF NOT EXISTS popular_games(
  gameid INTEGER PRIMARY KEY,
  Title TEXT,
  ReleaseDate TEXT,
  Rating NUMERIC,
  TimesListed NUMERIC,
  NumberofReviews NUMERIC,
  Summary TEXT,
  Plays NUMERIC,
  Playing NUMERIC,
  Backlogs NUMERIC,
  Wishlist NUMERIC
);
INSERT INTO popular_games
SELECT
	gameid,
	Title,
	ReleaseDate,
	Rating,
	CASE
		WHEN TimesListed LIKE '%K%' THEN SUBSTR(TimesListed, 1, INSTR(TimesListed, 'K') - 1) * 1000
		ELSE TimesListed
	END AS TimesListed,
	CASE
		WHEN NumberofReviews LIKE '%K%' THEN SUBSTR(NumberofReviews, 1, INSTR(NumberofReviews, 'K') - 1) * 1000
		ELSE NumberofReviews
	END AS NumberofReviews,
	Summary,
	CASE
		WHEN Plays LIKE '%K%' THEN SUBSTR(Plays, 1, INSTR(Plays, 'K') - 1) * 1000
		ELSE Plays
	END AS Plays,
	CASE
		WHEN Playing LIKE '%K%' THEN SUBSTR(Playing, 1, INSTR(Playing, 'K') - 1) * 1000
		ELSE Playing
		END AS Playing,
	CASE
		WHEN Backlogs LIKE '%K%' THEN SUBSTR(Backlogs, 1, INSTR(Backlogs, 'K') - 1) * 1000
		ELSE Backlogs
	END AS Backlogs,
	CASE
		WHEN Wishlist LIKE '%K%' THEN SUBSTR(Wishlist, 1, INSTR(Wishlist, 'K') - 1) * 1000
		ELSE Wishlist
	END AS Wishlist
FROM videogame;

/*Generate many to many tables */

/* Create many to many of game and genre */
CREATE TABLE IF NOT EXISTS vid_genre(
	gameid REFERENCES popular_games,
	genreid REFERENCES genre
);

INSERT INTO vid_genre
SELECT DISTINCT popular_games.gameid, genre.genreid
FROM game_1nf, genre, popular_games
WHERE  game_1nf.split_genre = genre.genre_name AND game_1nf.gameid = popular_games.gameid;

/* Create many to many of game and team*/
CREATE TABLE IF NOT EXISTS vid_team(
	gameid REFERENCES popular_games,
	teamid REFERENCES teams
);

INSERT INTO vid_team
SELECT DISTINCT popular_games.gameid, teams.teamid
FROM game_1nf, teams, popular_games
WHERE  game_1nf.split_team = teams.team_name AND game_1nf.gameid = popular_games.gameid;

/* Create many to many game and review*/

CREATE TABLE IF NOT EXISTS vid_review(
	gameid REFERENCES popular_games,
	reviewid REFERENCES review
);

INSERT INTO vid_review
SELECT DISTINCT popular_games.gameid, review.reviewid
FROM game_1nf, review, popular_games
WHERE  game_1nf.split_review = review.review_name AND game_1nf.gameid = popular_games.gameid;


/* Drop all unecessary tables */
-- dropping the unwanted tables
DROP TABLE split_t;
DROP TABLE split_g;
DROP TABLE split;
DROP TABLE split1;
DROP TABLE game_split;
DROP TABLE game;
DROP TABLE videogame;
DROP TABLE rev;
DROP TABLE split2;
DROP TABLE game_1nf;
