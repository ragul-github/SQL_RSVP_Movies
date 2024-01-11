USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


SELECT COUNT(*) AS director_mapping_rows 
FROM   director_mapping;
-- 'director_mapping' table has 3867 rows

SELECT COUNT(*) AS genre_rows
FROM   genre;
-- 'genre' table has 14662 rows

SELECT COUNT(*) AS movie_rows
FROM   movie;
-- 'movie' table has 7997 rows

SELECT COUNT(*) AS names_rows
FROM   `names`;
-- 'names' table has 25735 rows

SELECT COUNT(*) AS ratings_rows
FROM   ratings;
-- 'ratings' table has 7997 rows

SELECT COUNT(*) AS role_mapping_rows 
FROM   role_mapping;
-- 'role_mapping' table has 15615 rows


-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT SUM(CASE
             WHEN id IS NULL THEN 1           -- Case statement has been used to extract the number of rows with null values in each column from 'movie' table
             ELSE 0
           END) AS id_null_count,
       SUM(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_null_count,
       SUM(CASE
             WHEN `year` IS NULL THEN 1              -- grave accent (`) has been used in order to differentiate column name 'year' from reserved function word 'year'
             ELSE 0
           END) AS year_null_count,
       SUM(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null_count,
       SUM(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null_count,
       SUM(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_null_count,
       SUM(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS world_gross_null_count,
       SUM(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null_count,
       SUM(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS prod_comp_null_count
FROM   movie; 


-- Columns 'country', 'worlwide_gross_income', 'languages', 'production_company' has null values in the movie table


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT `year`,                                -- grave accent (`) has been used in order to differentiate column name 'year' from reserved function word 'year'        
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY `year`
ORDER  BY `year`;                            -- year 2017 has most of movies released with 3052 movies 


SELECT Month(date_published) AS month_num,
       COUNT(id)             AS number_of_movies
FROM   movie
GROUP  BY MONTH(date_published)
ORDER  BY MONTH(date_published);            -- Month of 'MARCH' has highest number of movies released accounting for 824 movies


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:



SELECT `year`,                         -- grave accent (`) has been used in order to differentiate column name 'year' from reserved function word 'year'        
       COUNT(id) AS number_of_movies
FROM   movie
WHERE  `year` = 2019
       AND ( country LIKE '%USA%'                  -- 'LIKE' operator with (%) has been used as the country column has values with more than one country in a single record. Eg: 'France, Iran, USA'
              OR country LIKE '%India%' );         -- 1059 movies were produced in India and USA in the year 2019



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM   genre;                          -- 13 unique genres could be found in genre table


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:



SELECT g.genre,
       COUNT(m.id) AS Count_of_Movies
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY COUNT(m.id) DESC
LIMIT  1;                          -- Limit has been used to extract only the top genre with highest number of movies produced

-- 4285 movies were produced in Drama genre which is highest among all the genres

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count
     AS (SELECT movie_id,
                COUNT(genre)
         FROM   genre
         GROUP  BY movie_id
         HAVING COUNT(genre) = 1)
SELECT COUNT(movie_id) AS Movies_With_One_Genre
FROM   genre_count;                                      -- 3289 movies belong to only one genre associated with them



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT g.genre,
       ROUND(AVG(m.duration), 2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY g.genre
ORDER  BY AVG(m.duration) DESC;      -- Action genre has highest average duration with 112.88 minutes


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_rank_table
     AS (SELECT genre,
                COUNT(movie_id)                    AS movie_count,
                RANK()
                  OVER(
                    ORDER BY COUNT(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank_table
WHERE  genre = 'Thriller';          -- Thriller genre is in the 3rd position with 1484 movies


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


WITH rating_rank
     AS (SELECT m.title,
                r.avg_rating,
                DENSE_RANK()
                  OVER(
                    ORDER BY avg_rating DESC) AS movie_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id)
SELECT *
FROM   rating_rank
WHERE  movie_rank <= 10;                                         -- kirket & Love in Kilnerry both the movies tops the table with average rating of 10.0


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY COUNT(movie_id) DESC;            -- Median rating 7 has highest number of movies with 2257


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_rank
     AS (SELECT m.production_company,
                COUNT(id)                     AS movie_count,
                DENSE_RANK()
                  OVER (
                    ORDER BY COUNT(id) DESC ) AS prod_company_rank                  
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   production_rank
WHERE  prod_company_rank = 1;                                -- To extract the top production house has produced the most number of hit movies


-- Dream Warrior Pictures & National Theatre Live, both the producation companies appears in the top position with 3 movies each

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT g.genre,
       COUNT(m.id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.`year` = 2017
       AND MONTH(m.date_published) = 03
       AND m.country LIKE '%USA%'
       AND r.total_votes > 1000
GROUP  BY g.genre
ORDER  BY COUNT(m.id) DESC;                   -- Drama genre has 24 movies released in march, 2017 in USA with more than 1000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT m.title,
       r.avg_rating,
       g.genre
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON g.movie_id = m.id
WHERE  m.title LIKE 'The%'
       AND r.avg_rating > 8;                 -- There are 8 movies that has title which begin with 'The' 
                                             -- 'The Brighton Miracle' has average rating of 9.5 comes under Drama genre


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT r.median_rating,
       COUNT(m.id) AS Movies_count
FROM   ratings AS r
       INNER JOIN movie AS m
               ON r.movie_id = m.id
WHERE  r.median_rating = 8
       AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY r.median_rating;                                          -- 361 movies have a median rating 8 has been released between 1st April 2018 and 1st April 2019


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:



SELECT m.country,
       SUM(r.total_votes) AS Total_Votes
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  country IN ( 'Germany', 'Italy' )
GROUP  BY m.country
ORDER  BY SUM(r.total_votes) DESC;               -- German movies have total votes of 106710 and Italian movies have 77965 votes.
                                                 -- Yes, German movies get more votes than Italian movies.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



SELECT SUM(CASE
             WHEN `name` IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       SUM(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       SUM(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       SUM(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   `names`; 



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH top_genre AS
(
           SELECT     g.genre,
                      COUNT(g.movie_id) AS movie_count
           FROM       genre             AS g
           INNER JOIN ratings           AS r
           ON         g.movie_id = r.movie_id
           WHERE      r.avg_rating > 8
           GROUP BY   g.genre
           ORDER BY   COUNT(g.movie_id) DESC LIMIT 3 ), top_directors AS
(
           SELECT     n.`name`                                      AS director_name,
                      COUNT(r.movie_id)                             AS movie_count,
                      RANK() OVER( ORDER BY COUNT(r.movie_id) DESC) AS director_rank
           FROM       `names`                                       AS n
           INNER JOIN director_mapping                              AS dm
           ON         n.id = dm.name_id
           INNER JOIN ratings AS r
           ON         r.movie_id = dm.movie_id
           INNER JOIN genre AS g
           ON         g.movie_id = dm.movie_id,
                      top_genre
           WHERE      r.avg_rating > 8
           AND        g.genre IN (top_genre.genre)
           GROUP BY   n.`name` )
SELECT director_name,
       movie_count
FROM   top_directors
WHERE  director_rank <=3;                                                          -- James Mangold appears top among the directors with average rating greater than 8 on the top three genres
                                                                                   -- Soubin Shahir, Joe Russo & Anthony Russo have movie count of 3 each 


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH actor_movie_count AS
(
           SELECT     n.`name`                                       AS actor_name,
                      COUNT(r.movie_id)                              AS movie_count,
                      RANK() OVER ( ORDER BY COUNT(r.movie_id) DESC) AS actor_rank
           FROM       `names`                                        AS n
           INNER JOIN role_mapping                                   AS rm
           ON         n.id = rm.name_id
           INNER JOIN ratings AS r
           ON         rm.movie_id = r.movie_id
           WHERE      median_rating >= 8
           AND        category ="actor"
           GROUP BY   n.`name` )
SELECT actor_name,
       movie_count
FROM   actor_movie_count
WHERE  actor_rank <=2;                                           -- Mammootty and Mohanlal appears in top two positions with 8 and 5 movies respectively


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_comp_rank
     AS (SELECT m.production_company,
                SUM(r.total_votes)                   AS vote_count,
                RANK()
                  OVER(
                    ORDER BY SUM(total_votes) DESC ) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         GROUP  BY m.production_company)
SELECT *
FROM   production_comp_rank
WHERE  prod_comp_rank <= 3;
                                                 -- Marvel Studios tops the table with total vote count of 2656967 followed by Twentieth Century Fox which has 2411163 votes



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH top_actor_avg_rank AS ( WITH actor_avg_rank AS
(
           SELECT     n.`name`                                                         AS actor_name,
                      SUM(r.total_votes)                                               AS total_votes,
                      COUNT(r.movie_id)                                                AS movie_count,
                      ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating          -- Weighted average has been calculated by ratio of sum of product of average rating and total votes to the sum of total votes
           FROM       `names`                                                          AS n
           INNER JOIN role_mapping                                                     AS rm
           ON         n.id = rm.name_id
           INNER JOIN ratings AS r
           ON         r.movie_id = rm.movie_id
           INNER JOIN movie AS m
           ON         m.id = rm.movie_id
           WHERE      rm.category = 'actor'
           AND        m.country LIKE '%India%'
           GROUP BY   n.`name`
           HAVING     COUNT(r.movie_id) >= 5 )
SELECT   *,
         RANK() OVER( ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM     actor_avg_rank )
SELECT *
FROM   top_actor_avg_rank
WHERE  actor_rank = 1;                                                                  -- Vijay Sethupathi tops the table with average rating of 8.42 



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH actress_rating_summary AS
(
           SELECT     n.`NAME`,
                      SUM(r.total_votes)                                                                                                   AS total_votes,
                      COUNT(r.movie_id)                                                                                                    AS movie_count,
                      ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)                                                     AS actress_avg_rating,
                      RANK() OVER(ORDER BY ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC, SUM(r.total_votes) DESC) AS actress_rank
           FROM       `names`                                                                                                              AS n
           INNER JOIN role_mapping                                                                                                         AS rm
           ON         n.id = rm.name_id
           INNER JOIN ratings AS r
           ON         r.movie_id = rm.movie_id
           INNER JOIN movie AS m
           ON         m.id = rm.movie_id
           WHERE      m.country LIKE '%India%'
           AND        m.languages LIKE '%Hindi%'
           AND        rm.category = 'actress'
           GROUP BY   n.`name`
           HAVING     COUNT(r.movie_id) >= 3 )
SELECT *
FROM   actress_rating_summary
WHERE  actress_rank <= 5;                                  -- Taapsee Pannu tops the table with average rating of 7.74, followed by Kriti Sanon with average rating of 7.05                            



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT DISTINCT m.title,
       r.avg_rating,
       ( CASE
           WHEN r.avg_rating > 8 THEN 'Superhit movies'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           ELSE 'Flop movies'
         END ) AS Movie_Rating_Category
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON g.movie_id = m.id
WHERE  g.genre = 'Thriller';                                             -- There are 785 One-time-watch movies, 492 Flop movies, 166 Hit movies and 39 Superhit movies


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


WITH genre_avg_summary AS
(
           SELECT     g.genre,
                      ROUND(AVG(m.duration),2) AS avg_duration
           FROM       genre                    AS g
           INNER JOIN movie                    AS m
           ON         g.movie_id = m.id
           GROUP BY   g.genre )
SELECT   * ,
         SUM(avg_duration) OVER w1   AS running_total_duration,
         AVG(avg_duration) OVER w2   AS moving_avg_duration
FROM     genre_avg_summary 
		 WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),                     -- Frames and window functions have been used to calculate moving average and running total.
                w2 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_genres AS
(
         SELECT   genre
         FROM     genre
         GROUP BY genre
         ORDER BY COUNT(movie_id) DESC LIMIT 3 ), top5_movie_summary AS
(
           SELECT     g.genre,
                      m.`year`,
                      m.title                                                                        AS movie_name,
                      CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                                        AS worldwide_gross_income,
                      DENSE_RANK() OVER(PARTITION BY m.`year` ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC) AS movie_rank
           FROM       genre                                                                          AS g
           INNER JOIN movie                                                                          AS m
           ON         g.movie_id = m.id,
                      top_genres
           WHERE      g.genre IN (top_genres.genre) )
SELECT *
FROM   top5_movie_summary
WHERE  movie_rank <= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH production_comp_rankings
     AS (SELECT m.production_company,
                COUNT(m.id)                     AS movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY COUNT(m.id) DESC ) AS prod_comp_rank
         FROM   movie AS m
                inner join ratings AS r
                        ON m.id = r.movie_id
         WHERE  r.median_rating >= 8
                AND POSITION(',' IN languages) >= 1
                AND m.production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   production_comp_rankings
WHERE  prod_comp_rank <= 2;                                     -- Star Cinema and Twentieth Century Fox tops the table with highest number of hits among multilingual movies


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_movie_rankings AS
(
           SELECT     n.`name`,
                      SUM(r.total_votes)                                              AS total_votes,
                      COUNT(r.movie_id)                                               AS movie_count,
                      ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actress_avg_rating,
                      RANK() OVER( ORDER BY COUNT(r.movie_id) DESC)                   AS actress_rank
           FROM       `names`                                                         AS n
           INNER JOIN role_mapping                                                    AS rm
           ON         n.id = rm.name_id
           INNER JOIN ratings AS r
           ON         r.movie_id = rm.movie_id
           INNER JOIN genre AS g
           ON         g.movie_id = r.movie_id
           WHERE      r.avg_rating > 8
           AND        rm.category = 'actress'
           AND        g.genre = 'drama'
           GROUP BY   n.`name` )
SELECT *
FROM   actress_movie_rankings
WHERE  actress_rank <= 3;

-- Parvathy Thiruvothu, Susan Brown & Amanda Lawrence are the top three actress based on number of Super Hit movies in drama genre


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
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:



WITH director_summary AS
(
           SELECT     n.id,
                      n.`name`,
                      dm.movie_id,
                      m.date_published,
                      LEAD(date_published,1) OVER(PARTITION BY `name` ORDER BY date_published, movie_id) AS next_movie_date,     -- Lead function has been used to make the next movie date appear on the column next to date of movie published 
                      r.avg_rating,
                      r.total_votes,
                      m.duration
           FROM       `names`          AS n
           INNER JOIN director_mapping AS dm
           ON         n.id = dm.name_id
           INNER JOIN movie AS m
           ON         dm.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           ORDER BY   n.`name`,
                      m.date_published ), date_difference_summary AS
(
       SELECT *,
              DATEDIFF(next_movie_date,date_published) AS date_difference                           -- The day difference between two movies of the director has been extracted here 
       FROM   director_summary )
SELECT   id                                                       AS director_id,
         `name`                                                   AS director_name,
         COUNT(movie_id)                                          AS number_of_movies,
         ROUND(AVG(date_difference))                              AS avg_inter_movie_days,
         ROUND(SUM(avg_rating * total_votes)/SUM(total_votes), 2) AS avg_rating,
         SUM(total_votes)                                         AS total_votes,
         MIN(avg_rating)                                          AS min_rating,
         MAX(avg_rating)                                          AS max_rating,
         SUM(duration)                                            AS total_duration
FROM     date_difference_summary
GROUP BY id
ORDER BY COUNT(movie_id) DESC LIMIT 9;

-- A.L. Vijay & Andrew Jones appears top on the table with 5 movies each with average inter movie days of 177 and 191 respectively.


