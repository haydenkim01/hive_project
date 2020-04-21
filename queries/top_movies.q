CREATE TABLE ratings (
  user_id INT,
  movie_id INT,
  rating INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/ml-100k/u.data' OVERWRITE INTO TABLE ratings;

CREATE TABLE users (
  user_id INT,
  age INT,
  gender STRING,
  occupation STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/ml-100k/u.user' OVERWRITE INTO TABLE users;

CREATE TABLE movies (
  movie_id INT,
  movie_title STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/ml-100k/u.item' OVERWRITE INTO TABLE movies;

CREATE TABLE top_movies (
  movie_title STRING,
  rating_cnt INT,
  rating_avg INT)
PARTITIONED BY (occupation STRING);

add FILE /hive_project/queries/top_movies.py;

set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE top_movies PARTITION (occupation)
SELECT
  movies.movie_title,
  COUNT(*) rating_cnt,
  AVG(ratings.rating) rating_avg,
  users.occupation
FROM ratings
JOIN users ON (ratings.user_id = users.user_id)
JOIN movies ON (ratings.movie_id = movies.movie_id)
GROUP BY users.occupation, movies.movie_title
HAVING rating_cnt > 5
ORDER BY users.occupation ASC, rating_avg DESC;
