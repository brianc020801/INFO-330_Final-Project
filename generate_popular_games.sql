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
