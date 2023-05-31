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