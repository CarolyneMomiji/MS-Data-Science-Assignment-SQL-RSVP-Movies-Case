USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
USE imdb;
SELECT table_name, table_rows 
FROM information_schema.tables 
WHERE table_schema = 'imdb';

-- director_mapping: 3867
-- genre: 14662
-- movie: 7467
-- names: 25374
-- ratings: 8230
-- role_mapping: 14402

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    IF(COUNT(*) - COUNT(id) > 0, 'id has NULL values', 'id has no NULL values') AS id_null_check,
    IF(COUNT(*) - COUNT(title) > 0, 'title has NULL values', 'title has no NULL values') AS title_null_check,
    IF(COUNT(*) - COUNT(year) > 0, 'year has NULL values', 'year has no NULL values') AS year_null_check,
    IF(COUNT(*) - COUNT(date_published) > 0, 'date_published has NULL values', 'date_published has no NULL values') AS date_published_null_check,
    IF(COUNT(*) - COUNT(duration) > 0, 'duration has NULL values', 'duration has no NULL values') AS duration_null_check,
    IF(COUNT(*) - COUNT(country) > 0, 'country has NULL values', 'country has no NULL values') AS country_null_check,
    IF(COUNT(*) - COUNT(worlwide_gross_income) > 0, 'worlwide_gross_income has NULL values', 'worlwide_gross_income has no NULL values') AS worlwide_gross_income_null_check,
    IF(COUNT(*) - COUNT(languages) > 0, 'languages has NULL values', 'languages has no NULL values') AS languages_null_check,
    IF(COUNT(*) - COUNT(production_company) > 0, 'production_company has NULL values', 'production_company has no NULL values') AS production_company_null_check
FROM movie;
-- 4 columns have null values: country, worlwide_gross_income, languages and production_company
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944	.		|
|	2019		|	2001	.		|
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 804			|
|	2			|	 640			|
|	3			|	 824			|
|	4			|	 680			|
|	5			|	 625			|
|	6			|	 580			|
|	6			|	 580			|
|	7			|	 493			|
|	8			|	 678			|
|	9			|	 809			|
|	10			|	 801			|
|	11			|	 625			|
|	12			|	 438			|
+---------------+-------------------+ */
-- Type your code below:
-- Query for the first part

SELECT 
    YEAR(date_published) AS Year, 
    COUNT(*) AS number_of_movies
FROM 
    movie
WHERE 
    date_published IS NOT NULL
GROUP BY 
    YEAR(date_published)
ORDER BY 
    Year;
-- Query for the second part
SELECT 
    MONTH(date_published) AS month_num, 
    COUNT(*) AS number_of_movies
FROM 
    movie
WHERE 
    date_published IS NOT NULL
GROUP BY 
    MONTH(date_published)
ORDER BY 
    month_num;
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(*) AS number_of_movies
FROM movie
WHERE YEAR(date_published) = 2019
  AND (UPPER(country) LIKE '%INDIA%' OR UPPER(country) LIKE '%USA%');
-- 1059 movies
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre FROM genre;
/* Output 
+-----------+
| genre     |
+-----------+
| Drama     |
| Fantasy   |
| Thriller  |
| Comedy    |
| Horror    |
| Family    |
| Romance   |
| Adventure |
| Action    |
| Sci-Fi    |
| Crime     |
| Mystery   |
| Others    |
+-----------+
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    g.genre, 
    COUNT(DISTINCT m.id) AS number_of_movies
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
GROUP BY 
    g.genre
ORDER BY 
    number_of_movies DESC
LIMIT 1;

/* Output 
+-------+------------------+
| genre | number_of_movies |
+-------+------------------+
| Drama |             4285 |
+-------+------------------+
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- 3289 movies only have one genre
-- Type your code below:
SELECT 
    COUNT(*) AS movies_with_one_genre
FROM 
    (SELECT movie_id
     FROM genre
     GROUP BY movie_id
     HAVING COUNT(genre) = 1) AS single_genre_movies;
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Action    |       112.88 |
| Romance   |       109.53 |
| Crime     |       107.05 |
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Comedy    |       102.62 |
| Adventure |       101.87 |
| Mystery   |       101.80 |
| Thriller  |       101.58 |
| Family    |       100.97 |
| Others    |       100.16 |
| Sci-Fi    |        97.94 |
| Horror    |        92.72 |
+-----------+--------------+ */
-- Type your code below:
SELECT 
    g.genre, 
    ROUND(AVG(m.duration), 2) AS avg_duration
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
WHERE 
    m.duration IS NOT NULL
GROUP BY 
    g.genre
ORDER BY 
    avg_duration DESC;
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+*/
-- Type your code below:
SELECT *
FROM (
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM 
        genre g
    JOIN 
        movie m ON g.movie_id = m.id
    GROUP BY 
        g.genre
) AS ranked_genres
WHERE genre = 'Thriller';
/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


--     ------------Segment 2:----------------

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | max_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM 
    ratings;
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          1 |
| Gini Helida Kathe              |        9.8 |          2 |
| Runam                          |        9.7 |          3 |
| Fan                            |        9.6 |          4 |
| Android Kunjappan Version 5.25 |        9.6 |          4 |
| Yeh Suhaagraat Impossible      |        9.5 |          5 |
| Safe                           |        9.5 |          5 |
| The Brighton Miracle           |        9.5 |          5 |
| Shibu                          |        9.4 |          6 |
+--------------------------------+------------+------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT 
    m.title, 
    r.avg_rating, 
    DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
ORDER BY 
    r.avg_rating DESC
LIMIT 10;
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             1 |          94 |
|             2 |         119 |
|             3 |         283 |
|             4 |         479 |
|             5 |         985 |
|             6 |        1975 |
|             7 |        2257 |
|             8 |        1030 |
|             9 |         429 |
|            10 |         346 |
+---------------+-------------+ */
-- Type your code below:
SELECT 
    median_rating,
    COUNT(movie_id) AS movie_count
FROM 
    ratings
GROUP BY 
    median_rating
ORDER BY 
    median_rating ASC;

-- Order by is good to have
/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------------+-------------+-------------------+
| production_company     | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
| Lietuvos Kinostudija   |           2 |                 3 |
| Swadharm Entertainment |           2 |                 3 |
| Panorama Studios       |           2 |                 3 |
+------------------------+-------------+-------------------+*/
-- Type your code below:
SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    r.avg_rating > 8
    AND m.production_company IS NOT NULL
GROUP BY 
    m.production_company
ORDER BY 
    movie_count DESC
LIMIT 5;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:
+----------+-------------+
| genre    | movie_count |
+----------+-------------+
| Drama    |          16 |
| Comedy   |           8 |
| Crime    |           5 |
| Horror   |           5 |
| Action   |           4 |
| Sci-Fi   |           4 |
| Thriller |           4 |
| Romance  |           3 |
| Fantasy  |           2 |
| Mystery  |           2 |
| Family   |           1 |
+----------+-------------+*/
-- Type your code below:
SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN
movie AS m
ON g.movie_id = m.id
INNER JOIN
ratings AS r
ON m.id = r.movie_id
WHERE (m.date_published BETWEEN '2017-03-01'AND '2017-03-31') AND (m.country = 'USA') AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;
-- Lets try to analyse with a unique problem statement.

-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| The Blue Elephant 2                  |    8.80000 | Drama    |
| The Blue Elephant 2                  |    8.80000 | Horror   |
| The Blue Elephant 2                  |    8.80000 | Mystery  |
| The Brighton Miracle                 |    9.50000 | Drama    |
| The Irishman                         |    8.70000 | Crime    |
| The Irishman                         |    8.70000 | Drama    |
| The Colour of Darkness               |    9.10000 | Drama    |
| Theeran Adhigaaram Ondru             |    8.30000 | Action   |
| Theeran Adhigaaram Ondru             |    8.30000 | Crime    |
| Theeran Adhigaaram Ondru             |    8.30000 | Thriller |
| The Mystery of Godliness: The Sequel |    8.50000 | Drama    |
| The Gambinos                         |    8.40000 | Crime    |
| The Gambinos                         |    8.40000 | Drama    |
| The King and I                       |    8.20000 | Drama    |
| The King and I                       |    8.20000 | Romance  |
+--------------------------------------+------------+----------+*/
-- Type your code below:

SELECT m.title, AVG(r.avg_rating) AS avg_rating, g.genre
FROM movie AS m
INNER JOIN ratings AS r ON m.id = r.movie_id
INNER JOIN genre AS g ON m.id = g.movie_id
WHERE m.title REGEXP '^The' AND r.avg_rating > 8
GROUP BY m.title, g.genre
HAVING AVG(r.avg_rating) > 8;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
/* Output format:
+--------+
| movies |
+--------+
|    361 |
+--------+*/
-- Type your code below:
SELECT COUNT(movie_id) AS movies
FROM 
ratings as ratings 
INNER JOIN 
movie AS movie
ON ratings.movie_id=movie.id
WHERE (movie.date_published BETWEEN '2018-04-01' AND '2019-04-01') AND (ratings.median_rating = 8)
GROUP BY ratings.median_rating;
-- Once again, try to solve the problem given below.

-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH german_summary AS (
    SELECT SUM(r.total_votes) AS german_total_votes,
           RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS unique_id
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE m.languages LIKE '%German%'
),
italian_summary AS (
    SELECT SUM(r.total_votes) AS italian_total_votes,
           RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS unique_id
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE m.languages LIKE '%Italian%'
)
SELECT g.german_total_votes, 
       i.italian_total_votes,
       CASE
           WHEN g.german_total_votes > i.italian_total_votes THEN 'Yes' 
           ELSE 'No' 
       END AS German_Movie_Is_Popular_Than_Italian_Movie
FROM german_summary g
JOIN italian_summary i ON g.unique_id = i.unique_id; 
-- Answer is Yes
/* Output format:
+--------------------+---------------------+--------------------------------------------+
| german_total_votes | italian_total_votes | German_Movie_Is_Popular_Than_Italian_Movie |
+--------------------+---------------------+--------------------------------------------+
|            4421525 |             2559540 | Yes                                        |
+--------------------+---------------------+--------------------------------------------+*/

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+*/
-- Type your code below:
SELECT COUNT(*)-COUNT(name) AS name_nulls, 
		COUNT(*)-COUNT(height) AS height_nulls, 
		COUNT(*)-COUNT(date_of_birth) AS date_of_birth_nulls, 
		COUNT(*)-COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:
+---------------+-------------+
| director_name | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Joe Russo     |           3 |
| Anthony Russo |           3 |
+---------------+-------------+ */
-- Type your code below:
WITH genre_top3 AS
(
	SELECT g.genre, COUNT(g.movie_id) AS movie_count
	FROM movie AS m
	INNER JOIN genre AS g
	ON m.id=g.movie_id
	INNER JOIN ratings AS r
	ON m.id=r.movie_id
	WHERE r.avg_rating>8
	GROUP BY genre
	ORDER BY movie_count DESC
	LIMIT 3
)
SELECT n.name as director_name, COUNT(m.id) as movie_count
FROM names AS n
INNER JOIN director_mapping AS d
ON n.id=d.name_id
INNER JOIN movie AS m
ON d.movie_id=m.id
INNER JOIN genre AS g
ON m.id=g.movie_id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE r.avg_rating>8 AND g.genre IN (SELECT genre FROM genre_top3)
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3; 
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+------------+-------------+
| actor_name | movie_count |
+------------+-------------+
| Mammootty  |           8 |
| Mohanlal   |           5 |
+------------+-------------+ */
-- Type your code below:
SELECT 
n.name AS actor_name, COUNT(m.id) AS movie_count
FROM names n
inner join role_mapping a ON n.id = a.name_id
inner join movie m ON a.movie_id = m.id
inner join ratings r ON m.id = r.movie_id
WHERE  r.median_rating >= 8  AND a.category = 'actor'
GROUP BY n.name
ORDER By  movie_count DESC limit 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+-----------------------+-------------+------------+
| production_company    | total_votes | votes_rank |
+-----------------------+-------------+------------+
| Marvel Studios        |     2656967 |          1 |
| Twentieth Century Fox |     2411163 |          2 |
| Warner Bros.          |     2396057 |          3 |
+-----------------------+-------------+------------+*/
-- Type your code below:
SELECT m.production_company, SUM(r.total_votes) AS total_votes, 
RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS votes_rank
FROM movie AS m
inner join  ratings AS r 
ON m.id = r.movie_id
GROUP BY  m.production_company
ORDER BY votes_rank
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+------------------+-------------+-------------+------------------+------------+
| actor_name       | total_votes | movie_count | actor_avg_rating | actor_rank |
+------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi |       23114 |           5 |             8.42 |          1 |
+------------------+-------------+-------------+------------------+------------+*/
-- Type your code below:
WITH indian_actor AS
(
SELECT 
	name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/ SUM(total_votes), 2) AS actor_avg_rating,
    RANK() OVER(ORDER BY SUM(total_votes * avg_rating)/ SUM(total_votes) DESC, SUM(total_votes) DESC) AS actor_rank
FROM
	names n
		INNER JOIN
	role_mapping rm ON rm.name_id = n.id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
		INNER JOIN
	movie m ON m.id = r.movie_id
WHERE country REGEXP 'India' AND category = 'actor'
GROUP BY name
HAVING movie_count >= 5 
)
SELECT *
FROM indian_actor
WHERE actor_rank = 1 ;

-- Ovservations:
-- Vijay Sethupati has highest rating with 8.42 with 5 movies reliesed in India with 23114 Votes
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Kriti Sanon     |       21967 |           3 |               7.05 |            2 |
| Divya Dutta     |        8579 |           3 |               6.88 |            3 |
| Shraddha Kapoor |       26779 |           3 |               6.63 |            4 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            5 |
+-----------------+-------------+-------------+--------------------+--------------+*/
-- Type your code below:
WITH indian_actress AS
(
SELECT 
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/ SUM(total_votes), 2) AS actress_avg_rating,
    RANK() OVER(ORDER BY SUM(total_votes * avg_rating)/ SUM(total_votes) DESC, SUM(total_votes) DESC) AS actress_rank
FROM
	names n
		INNER JOIN
	role_mapping rm ON rm.name_id = n.id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
		INNER JOIN
	movie m ON m.id = r.movie_id
WHERE country REGEXP 'India' AND category = 'actress' AND languages REGEXP 'Hindi'
GROUP BY name
HAVING movie_count >= 3
)
SELECT *
FROM indian_actress
WHERE actress_rank <= 5 ;

-- Observations:
-- Top actress names by average ratings: 
	-- Taapsee Pannu - 7.74
	-- Kriti Sanon - 7.05
	-- Divya Dutta - 6.88
	-- Shraddha Kapoor - 6.33
	-- Kriti Kharbanda - 4.80

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
	title,
    avg_rating,
    (CASE
		WHEN avg_rating >8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
        END ) AS movie_category
FROM
	movie m
		INNER JOIN
	ratings r ON m.id = r.movie_id
		INNER JOIN
	genre g ON r.movie_id = g.movie_id
WHERE genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Horror    |      92.7243 |                  92.72 |               92.72 |
| Sci-Fi    |      97.9413 |                 190.67 |               95.33 |
| Others    |     100.1600 |                 290.83 |               96.94 |
| Family    |     100.9669 |                 391.79 |               97.95 |
| Thriller  |     101.5761 |                 493.37 |               98.67 |
| Mystery   |     101.8000 |                 595.17 |               99.19 |
| Adventure |     101.8714 |                 697.04 |               99.58 |
| Comedy    |     102.6227 |                 799.66 |               99.96 |
| Fantasy   |     105.1404 |                 904.80 |              100.53 |
| Drama     |     106.7746 |                1011.58 |              101.16 |
| Crime     |     107.0517 |                1118.63 |              101.69 |
| Romance   |     109.5342 |                1228.16 |              102.35 |
| Action    |     112.8829 |                1341.05 |              103.16 |
+-----------+--------------+------------------------+---------------------+*/
-- Type your code below:
WITH genre_wise_avg_duration AS
(
	SELECT 
		genre,
		AVG(duration) AS avg_duration
	FROM 
		genre g
			INNER JOIN
		movie m ON g.movie_id = m.id
	GROUP BY genre
)
SELECT 
	*,
    ROUND(SUM(avg_duration) OVER w, 2) AS running_total_duration,
    ROUND(AVG(avg_duration) OVER w, 2) AS moving_avg_duration
FROM 
	genre_wise_avg_duration
WINDOW 
w AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING)
;

-- Observations: Action and Romance genre have high average duration for movies.
-- Romance	109.5342
-- Action	112.8829

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+----------+------+--------------------------------+----------------------------+------------+
| genre    | year | movie_name                     | worldwide_gross_income ($) | movie_rank |
+----------+------+--------------------------------+----------------------------+------------+
| Thriller | 2017 | The Fate of the Furious        |                 1236005118 |          1 |
| Comedy   | 2017 | Despicable Me 3                |                 1034799409 |          2 |
| Comedy   | 2017 | Jumanji: Welcome to the Jungle |                  962102237 |          3 |
| Drama    | 2017 | Zhan lang II                   |                  870325439 |          4 |
| Thriller | 2017 | Zhan lang II                   |                  870325439 |          4 |
| Comedy   | 2017 | Guardians of the Galaxy Vol. 2 |                  863756051 |          5 |
| Drama    | 2018 | Bohemian Rhapsody              |                  903655259 |          1 |
| Thriller | 2018 | Venom                          |                  856085151 |          2 |
| Thriller | 2018 | Mission: Impossible - Fallout  |                  791115104 |          3 |
| Comedy   | 2018 | Deadpool 2                     |                  785046920 |          4 |
| Comedy   | 2018 | Ant-Man and the Wasp           |                  622674139 |          5 |
| Drama    | 2019 | Avengers: Endgame              |                 2797800564 |          1 |
| Drama    | 2019 | The Lion King                  |                 1655156910 |          2 |
| Comedy   | 2019 | Toy Story 4                    |                 1073168585 |          3 |
| Drama    | 2019 | Joker                          |                  995064593 |          4 |
| Thriller | 2019 | Joker                          |                  995064593 |          4 |
| Thriller | 2019 | Ne Zha zhi mo tong jiang shi   |                  700547754 |          5 |
+----------+------+--------------------------------+----------------------------+------------+*/
-- Type your code below:
WITH top3genre AS(
	SELECT genre
	FROM
		genre
	GROUP BY genre
	ORDER BY COUNT(movie_id) DESC
	LIMIT 3
), currency_converted AS
(
SELECT
	id,
    CASE
		 WHEN worlwide_gross_income LIKE 'INR%' 
			THEN Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(12)) / 75
		 WHEN worlwide_gross_income LIKE '$%' 
			THEN Cast(Replace(worlwide_gross_income, '$', '') AS DECIMAL(12))
		 ELSE Cast(worlwide_gross_income AS DECIMAL(12))
	END AS worldwide_gross_income
FROM 
	movie
), ranked_movies AS
(SELECT 
	genre,
	year,
    title AS movie_name,
	ROUND(cc.worldwide_gross_income) AS 'worldwide_gross_income ($)',
    DENSE_RANK() OVER(PARTITION BY year ORDER BY cc.worldwide_gross_income DESC) movie_rank
FROM
	movie m
		INNER JOIN
    genre g ON m.id = g.movie_id
		INNER JOIN 
	currency_converted cc On cc.id = m.id
WHERE genre IN (SELECT * FROM top3genre)
)
SELECT* FROM ranked_movies
WHERE movie_rank <=5 ;

/*
Observations: Top 5 movies by gross world-wide income

2017	The Fate of the Furious
		Despicable Me 3
		Jumanji: Welcome to the Jungle
		Zhan lang II
		Guardians of the Galaxy Vol. 2
        
2018	Bohemian Rhapsody
		Venom
		Mission: Impossible - Fallout
		Deadpool 2
		Ant-Man and the Wasp

2019	Avengers: Endgame
		The Lion King
		Toy Story 4
		Joker
		Ne Zha zhi mo tong jiang shi
        
	/*
-- Top 3 Genres based on most number of movies
-- Drama
-- Comedy
-- Thriller

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+*/
-- Type your code below:
WITH production_company_rank as
(
SELECT
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) prod_comp_rank
FROM
	movie m
		INNER JOIN
	ratings r ON m.id = r.movie_id
WHERE median_rating >= 8 AND POSITION(',' IN languages)>0 AND production_company IS NOT NULL
GROUP BY production_company
)
SELECT *
FROM production_company_rank
WHERE prod_comp_rank <=2 ;

-- Observations: 
-- Star Cinema, Twentieth Century Fox are top 2 production companys which produced higher number of Multilingual movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------------+-------------+-------------+--------------------+--------------+
| actress_name        | total_votes | movie_count | actress_avg_rating | actress_rank |
+---------------------+-------------+-------------+--------------------+--------------+
| Parvathy Thiruvothu |        4974 |           2 |               8.25 |            1 |
| Susan Brown         |         656 |           2 |               8.94 |            2 |
| Amanda Lawrence     |         656 |           2 |               8.94 |            3 |
+---------------------+-------------+-------------+--------------------+--------------+*/
-- Type your code below:
WITH actress_ranking AS
(
SELECT 
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/SUM(total_votes), 2) AS actress_avg_rating,
	ROW_NUMBER() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank 
FROM
	names n
		INNER JOIN
	role_mapping rm ON n.id = rm.name_id
		INNER JOIN
	genre g ON g.movie_id = rm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
WHERE avg_rating > 8 AND genre = 'Drama' AND category = 'actress'
GROUP BY name 
)
SELECT *
FROM actress_ranking
WHERE actress_rank <=3 ;

-- Observations:
-- 	Top 3 actress: 
-- 	Parvathy Thiruvothu, Susan Brown, Amanda Lawrence 

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm1777967   | A.L. Vijay        |                5 |               176.75 |       5.65 |        1754 |        3.7 |        6.9 |            613 |
| nm2096009   | Andrew Jones      |                5 |               190.75 |       3.04 |        1989 |        2.7 |        3.2 |            432 |
| nm0001752   | Steven Soderbergh |                4 |               254.33 |       6.77 |      171684 |        6.2 |        7.0 |            401 |
| nm0425364   | Jesse V. Johnson  |                4 |               299.00 |       6.10 |       14778 |        4.2 |        6.5 |            383 |
| nm0515005   | Sam Liu           |                4 |               260.33 |       6.32 |       28557 |        5.8 |        6.7 |            312 |
| nm0814469   | Sion Sono         |                4 |               331.00 |       6.31 |        2972 |        5.4 |        6.4 |            502 |
| nm0831321   | Chris Stokes      |                4 |               198.33 |       4.32 |        3664 |        4.0 |        4.6 |            352 |
| nm2691863   | Justin Price      |                4 |               315.00 |       4.93 |        5343 |        3.0 |        5.8 |            346 |
| nm6356309   | Özgür Bakar       |                4 |               112.00 |       3.96 |        1092 |        3.1 |        4.9 |            374 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_info AS
(
SELECT
	dm.name_id AS director_id,
    name AS director_name,
    dm.movie_id AS movie_id,
    date_published,
    LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published) AS next_date_published,
    total_votes,
    avg_rating,
    duration
FROM
	names n
		INNER JOIN
	director_mapping dm ON dm.name_id = n.id
		INNER JOIN 
	movie m ON m.id = dm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = m.id
), top_directors AS
(
SELECT 
	director_id,
    director_name,
	COUNT(movie_id) number_of_movies,
	ROUND(AVG(datediff(next_date_published, date_published)), 2) as avg_inter_movie_days,
    ROUND(SUM(avg_rating * total_votes)/ SUM(total_votes), 2) AS avg_rating,
    SUM(total_votes)AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) as movie_rank
FROM
	director_info
GROUP BY director_id 
)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  movie_rank <= 9;


/*
Observations:
Based on movies directed these are the top 9 directores: 
	A.L. Vijay
	Andrew Jones
	Steven Soderbergh
	Jesse V. Johnson
	Sam Liu
	Sion Sono
	Chris Stokes
	Justin Price
	Özgür Bakar
*/
