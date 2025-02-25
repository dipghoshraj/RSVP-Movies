USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';


+------------------+------------+
| TABLE_NAME       | TABLE_ROWS |
+------------------+------------+
| director_mapping |       3867 |
| genre            |      14662 |
| movie            |       8987 |
| names            |      24584 |
| ratings          |       8230 |
| role_mapping     |      15158 |
+------------------+------------+



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
 
-- id        | title         | year | date_published | duration | country | worlwide_gross_income | languages | production_company

use imdb;

SELECT

Sum(CASE
	WHEN id IS NULL THEN 1
	ELSE 0
	END) AS ID_NC,
Sum(CASE
	WHEN title IS NULL THEN 1
	ELSE 0
	END) AS title_NC,
Sum(CASE
	WHEN year IS NULL THEN 1
	ELSE 0
	END) AS year_NC,
Sum(CASE
	WHEN date_published IS NULL THEN 1
	ELSE 0
	END) AS date_published_NC,
Sum(CASE
	WHEN duration IS NULL THEN 1
	ELSE 0
	END) AS duration_NC,
Sum(CASE
	WHEN country IS NULL THEN 1
	ELSE 0
	END) AS country_NC,
Sum(CASE
	WHEN worlwide_gross_income IS NULL THEN 1
	ELSE 0
	END) AS worlwide_gross_income_NC,
Sum(CASE
	WHEN languages IS NULL THEN 1
	ELSE 0
	END) AS languages_NC,
Sum(CASE
	WHEN production_company IS NULL THEN 1
	ELSE 0
	END) AS production_company_NC

FROM movie; 


+-------+----------+---------+-------------------+-------------+------------+--------------------------+--------------+-----------------------+
| ID_NC | title_NC | year_NC | date_published_NC | duration_NC | country_NC | worlwide_gross_income_NC | languages_NC | production_company_NC |
+-------+----------+---------+-------------------+-------------+------------+--------------------------+--------------+-----------------------+
|     0 |        0 |       0 |                 0 |           0 |         20 |                     3724 |          194 |                   528 |
+-------+----------+---------+-------------------+-------------+------------+--------------------------+--------------+-----------------------+



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

use imdb;
SELECT Year, Count(title) AS number_of_movies FROM movie GROUP  BY Year;

+------+------------------+
| Year | number_of_movies |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+

use imdb;
SELECT Month(date_published) AS month_num, Count(*) AS number_of_movies FROM movie GROUP BY month_num;

+-----------+------------------+
| month_num | number_of_movies |
+-----------+------------------+
|         6 |              580 |
|        12 |              438 |
|        11 |              625 |
|         1 |              804 |
|        10 |              801 |
|         2 |              640 |
|         9 |              809 |
|         4 |              680 |
|         3 |              824 |
|         8 |              678 |
|         5 |              625 |
|         7 |              493 |
+-----------+------------------+




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

use imdb;
SELECT Count(DISTINCT id) AS movies, year FROM movie WHERE (country LIKE '%USA%' OR country LIKE '%INDIA%') AND year = 2019;

+--------+------+
| movies | year |
+--------+------+
|   1059 | 2019 |
+--------+------+

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

use imdb;
SELECT DISTINCT genre FROM genre; 


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

use imdb;

SELECT genre, Count(*) AS movies_no FROM movie
INNER JOIN genre AS g WHERE g.movie_id = movie.id
GROUP BY genre ORDER BY movies_no DESC LIMIT 1;


+-------+-----------+
| genre | movies_no |
+-------+-----------+
| Drama |      4285 |
+-------+-----------+


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

use imdb;

SELECT COUNT(*) AS movie_no
FROM genre g1 WHERE NOT EXISTS 
(
SELECT 1 FROM genre g2 WHERE g2.movie_id = g1.movie_id 
AND g2.genre <> g1.genre
)


+----------+
| movie_no |
+----------+
|     3289 |
+----------+



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


use imdb;

SELECT genre, Round(Avg(duration)) AS avg_duration
FROM movie INNER JOIN genre
ON genre.movie_id = movie.id 
GROUP BY genre ORDER BY avg_duration DESC;

+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Action    |          113 |
| Romance   |          110 |
| Drama     |          107 |
| Crime     |          107 |
| Fantasy   |          105 |
| Comedy    |          103 |
| Thriller  |          102 |
| Adventure |          102 |
| Mystery   |          102 |
| Family    |          101 |
| Others    |          100 |
| Sci-Fi    |           98 |
| Horror    |           93 |
+-----------+--------------+




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

-- use imdb;

-- WITH genre_summary AS
-- ( SELECT genre, Count(movie_id) AS movie_count, Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank FROM genre GROUP BY genre )
-- SELECT * FROM genre_summary;

use imdb;

WITH genre_summary AS
( SELECT genre, Count(movie_id) AS movie_count, Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank FROM genre GROUP BY genre )
SELECT * FROM genre_summary WHERE  genre = "THRILLER" ;

+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+




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


use imdb;

SELECT 
	Min(avg_rating) AS min_avg_rating,
	Max(avg_rating) AS max_avg_rating,
	Min(total_votes) AS min_total_votes,
	Max(total_votes) AS max_total_votes,
	Min(median_rating) AS min_median_rating,
	Max(median_rating) AS min_median_rating
FROM ratings; 

+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | min_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+


    

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



SELECT title, avg_rating, Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM  ratings INNER JOIN movie
ON movie.id = ratings.movie_id limit 10;


+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          1 |
| Gini Helida Kathe              |        9.8 |          3 |
| Runam                          |        9.7 |          4 |
| Fan                            |        9.6 |          5 |
| Android Kunjappan Version 5.25 |        9.6 |          5 |
| Yeh Suhaagraat Impossible      |        9.5 |          7 |
| Safe                           |        9.5 |          7 |
| The Brighton Miracle           |        9.5 |          7 |
| Shibu                          |        9.4 |         10 |
+--------------------------------+------------+------------+


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


use imdb;

SELECT median_rating, Count(movie_id) AS movie_count
FROM ratings GROUP BY median_rating ORDER  BY movie_count DESC;


+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             7 |        2257 |
|             6 |        1975 |
|             8 |        1030 |
|             5 |         985 |
|             4 |         479 |
|             9 |         429 |
|            10 |         346 |
|             3 |         283 |
|             2 |         119 |
|             1 |          94 |
+---------------+-------------+



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


use imdb;

WITH production_company_hit_movie_summary
AS (
	SELECT production_company, Count(movie_id) AS MOVIE_COUNT, Rank()
    OVER(
    ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
	FROM   ratings AS R INNER JOIN movie AS M ON M.id = R.movie_id
    WHERE  avg_rating > 8 AND production_company IS NOT NULL GROUP BY production_company
)
SELECT * FROM production_company_hit_movie_summary WHERE prod_company_rank = 1;


+------------------------+-------------+-------------------+
| production_company     | MOVIE_COUNT | PROD_COMPANY_RANK |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+


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


use imdb;

SELECT genre, Count(M.id) AS MOVIE_COUNT
FROM movie AS M
INNER JOIN genre AS G ON G.movie_id = M.id
INNER JOIN ratings AS R ON R.movie_id = M.id
WHERE  year = 2017
AND Month(date_published) = 3 AND country LIKE '%USA%' AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC;


+-----------+-------------+
| genre     | MOVIE_COUNT |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+



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









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:








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









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:









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







