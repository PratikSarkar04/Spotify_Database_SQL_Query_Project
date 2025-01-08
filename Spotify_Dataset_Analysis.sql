-- SQL Project of Spotify Datasets and Related Queries --
DROP TABLE IF EXISTS spotify;
CREATE TABLE IF NOT EXISTS spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
	valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


-- Exploratory Data Analysis (EDA)

SELECT * FROM spotify;

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-- -----------------------------------------
-- Data analysis for some business problems 
-- -----------------------------------------

-- Q1. Retrieve the names of all tracks that have more than 1 billon streams.

SELECT track, stream FROM spotify
WHERE stream >= 100000000
ORDER BY stream DESC;

-- Q2. List all albums along with their respective artists.

SELECT DISTINCT artist,album FROM spotify
ORDER BY album;

-- Q3. Get the total number of comments for tracks where licensed = 'true'.

SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed = 'true';

-- Q4. Find all tracks that belong to the album type single.

SELECT track, album_type FROM spotify
WHERE album_type ILIKE 'single';

-- Q5. Count the total number of tracks by each artists.

SELECT artist,
	COUNT(track) AS total_track
FROM spotify
GROUP BY artist
ORDER BY total_track;

-- Q6. Calculate the average dancebility of tracks in each album.

SELECT album, track,
	AVG(danceability) AS avg_danceability 
FROM spotify
GROUP BY album, track
ORDER BY avg_danceability DESC;

-- Q7. Find the top 5 tracks with the highest energy values.

SELECT track,
	MAX(energy) AS highest_energy
FROM spotify
GROUP BY track 
ORDER BY highest_energy DESC
LIMIT 5;

-- Q8. List all tracks along with their views and likes where offical_video is true.

SELECT track,
	SUM(views) as total_views,
	SUM(likes) as total_likes,
	official_video
FROM spotify
WHERE official_video = 'true'
GROUP BY track, official_video;

-- Q9. For each album, calculate the total views of all associated tracks.

SELECT track, album,
	SUM(views) AS total_views
FROM spotify
GROUP BY track, album
ORDER BY 3 DESC;

-- Q10. Retrieve the track names that have been streamed on spotify more than Youtube.

SELECT * FROM
(SELECT 
	track,
	COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
) AS t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND 
	streamed_on_youtube <> 0;

-- Q11. Find the top 3 most-viewed tracks for each artist using window function.

WITH ranking_artist
AS
(SELECT 
	artist,
	track,
	SUM(views) AS total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)
SELECT * FROM ranking_artist
WHERE rank <=3;

--Q12. Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
GROUP BY 1,2
ORDER BY 2 DESC;

--Q13. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT 
	track,
	energy,
	liveness,
	energy_liveness
FROM spotify
WHERE energy_liveness >= 1.2
GROUP BY 1,2,3,4
ORDER BY 4 DESC;
-- Another Method --
SELECT 
	energy, 
	liveness,
	(energy/liveness) AS energy_liveness_ratio
FROM spotify
WHERE (energy/liveness) >= 1.2
GROUP BY 1,2
ORDER BY 3 DESC;

-- Q14. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT * FROM Spotify ;

SELECT 
	track,
	SUM(likes) OVER (ORDER BY (views)) AS cumulative_sum
FROM Spotify
	ORDER BY 2 DESC;





