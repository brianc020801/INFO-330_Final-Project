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
DROP TABLE split_t
DROP TABLE split_g
DROP TABLE split
DROP TABLE split1
DROP TABLE game_split
DROP TABLE game
DROP TABLE videogame
DROP TABLE rev
