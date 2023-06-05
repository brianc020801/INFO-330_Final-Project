/*Brain*/
-- Which 6 game genre has the highest average amount of reviews?--
SELECT g.genre_name,  AVG(NumberofReviews) AS avg_review
FROM genre as g, vid_genre as vg, popular_games as p
WHERE g.genreid = vg.genreid AND p.gameid = vg.gameid
GROUP BY g.genreid
ORDER BY avg_review DESC
LIMIT 6;
-- What is the best selling adventure game each year?--
SELECT strftime('%Y', p.ReleaseDate) AS Year, p.Title, MAX(p.Plays + p.Playing) AS total_plays
FROM popular_games AS p, genre AS g, vid_genre AS vg
WHERE p.gameid = vg.gameid AND vg.genreid = g.genreid AND g.genre_name = 'Adventure' AND Year > 0
GROUP BY Year
ORDER BY Year DESC;

/*Qinyi*/
-- Find the average number of players currently playing for each genre--
SELECT g.genre_name, AVG(pg.Playing) as Average_Playing
FROM popular_games pg
JOIN vid_genre vg ON pg.gameid = vg.gameid
JOIN genre g ON vg.genreid = g.genreid
GROUP BY g.genre_name
ORDER BY Average_Playing DESC;
-- Find the average number of players in backlog for each genre--
SELECT g.genre_name, AVG(pg.backlogs) as Average_Backlogs
FROM popular_games pg
JOIN vid_genre vg ON pg.gameid = vg.gameid
JOIN genre g ON vg.genreid = g.genreid
GROUP BY g.genre_name
ORDER BY Average_Backlogs DESC;

/*Karen*/
-- What are the most played video games  of each year from 2013 to 2023?--
​​SELECT strftime('%Y', ReleaseDate) AS Year, Title, MAX(Plays) AS Plays
FROM popular_games
WHERE ReleaseDate BETWEEN '2013-01-01' AND '2023-12-31'
GROUP BY Year
ORDER BY Year DESC;

-- Which developer has the highest average rating of their games? --
SELECT teams.teamid, teams.team_name, AVG(popular_games.Rating) AS avg_rating
FROM teams
JOIN vid_team  ON teams.teamid  = vid_team.teamid
JOIN popular_games ON vid_team.gameid = popular_games.gameid
GROUP BY teams.teamid, teams.team_name
ORDER BY avg_rating DESC
LIMIT 1;
