/*E1: Create a Schema and Tables */

CREATE SCHEMA MyfirstDB;
USE MyfirstDB;

#Defining the columns with its designated data type
CREATE TABLE actor(
	aid SMALLINT UNSIGNED, #stores exact, non-negative whole numbers
    first_name VARCHAR(20), #VARCHAR = Variable Character used to store text strings of varying lengths
    last_name VARCHAR(20),
    YOB YEAR,
    PRIMARY KEY(aid) #Alt: aid SMALLINT UNSIGNED PRIMARY KEY
);

CREATE TABLE movie(
	movie_id SMALLINT UNSIGNED PRIMARY KEY, #movie's primay key makes each movie unique 
    title VARCHAR(50),
    release_year YEAR
);

CREATE TABLE mcast(
	movie_id SMALLINT UNSIGNED,
    aid SMALLINT UNSIGNED,
    arole VARCHAR(20),
    
    PRIMARY KEY (movie_id, aid), #mcast's primary key makes each movie-actor pair unique 
    FOREIGN KEY (movie_id) REFERENCES movie (movie_id), #becomes foreign key
	FOREIGN KEY (aid) REFERENCES actor(aid)
);

CREATE TABLE country(
	cid SMALLINT UNSIGNED PRIMARY KEY,
    country_name VARCHAR(20)
);

# E2: Delete and Recover Tables: Delete the following relations (tables) from the database (in this order):
#E2.1 country
DROP TABLE country; #DROP is used to permanently delete database objects/structure/associated data from the system

#E2.2 movie
DROP TABLE movie; #Error Code: Cannot directly drop a table that is referenced by a foreign key constraint

#E2.3 mcast
DROP TABLE mcast;

#E2.3.1: Drop TABLE movie again.
DROP TABLE movie; #Works b/c we dropped child table: mcast

#Recover(recreate) the country, movie, and mcast relations, if applicable.

#E3: Modify Table Schema
#3.1 Add the attributes(columns) myrank and imdbrank to the movie table of type smallint
ALTER TABLE movie 
	ADD myrank SMALLINT, 
    ADD imdbrank SMALLINT;

#3.2 Drop attribute country_name from country table
ALTER TABLE country
	DROP country_name;

#3.3 Change the type of attribute imdbrank and myrank from smallint to float
ALTER TABLE movie
	MODIFY imdbrank float,
    MODIFY myrank float;
    
#3.4 Rename table country to region
ALTER TABLE country RENAME region;
#alternative:
RENAME TABLE country TO region;
#alternative:
ALTER TABLE country RENAME TO region;
    
#3.5 Rename attributte cid to rid
ALTER TABLE region RENAME COLUMN cid TO rid;

#E4: Insert Data into Tables

#E4.1 Insance of relation actor - Inserting multiplpe values at a time
INSERT INTO actor
	VALUES(2, "Andy", "Griffin", 1926), (3, "Walter", "Matthau", 1920), (71, "Mel","Brooks", 1926), (72, "Audrey", "Hepburn", 1929),(73, "Walter","Matthau", 1920), (74,"Cary","Grant",1904);

#E4.2 Instance of relation mcast. Inserting multiple values at a time
INSERT INTO mcast
	VALUES(1,2, "Larry Rodes"), (1,3, "Mel Miller"), (5,72, "Regina Lampert"), (5,73, "Carson Dyle"),(5,74,"Brian Cruikshank");

#E4.3 Instnace of relation movie
INSERT INTO movie(movie_id, title, release_year)
	VALUES(1, "A Face in the Crowd", 1957), (5, "Charade", 1963);
    
#E5: Add the following data: Insert the following additional tuples into movie relation (write seperate INSERT statements for each)

#5.1 Title "12 Angry Men", released in 1957, movie_id is 100, and IMDB rank is 9
INSERT INTO movie (movie_id, title, release_year, myrank, imdbrank)
VALUES(100, "12 Angry Men", 1957,NULL, 9);

#Swapping NULL and 9 in order to follow the table's column order ^
UPDATE movie
SET myrank = NULL, imdbrank = 9
WHERE movie_id = 100; #uniquely identifies one row!

SELECT * FROM movie;

#5.2 Movie_id is 5, title is "Funny Face", released in 1957, IMDB rank is 7
INSERT INTO movie
VALUES(5, "Funny Face", 1957, NULL, 7); #Error: Violates the primary key constraint. Duplicate of movie_id(5). Primary key must be unique.

#5.3 Movie_id is 7, "Oppenheimer", release in 2023, IMDB rank is 8.3
## Movie_id is 8, "Barbie", released in 2023, IMDB rank is 6.8.

INSERT INTO movie
VALUES(7, "Oppenheimer", 2023, NULL, 8.3), (8, "Barbie", 2023, NULL, 6.8); 


#5.4 Insert the following additional tuples into the mcast relation: 
## Movie_id is 10, aid is 7, actor's role is “Regina”.
INSERT INTO mcast
VALUES(10, 7, "Regina"); #Error: Violates the foreign key constraint

 #E6: Update myrank
 #6.1 Check values assigned to myrank in existing tuples
 SELECT * FROM movie;
 
 #6.2 Set sql_safe_updates = 0; to disable the safe update mode. 
SET sql_safe_updates = 0; #turns off a safety feature that prevents u from accidently overwriting/deleting your entire database

#6.3 Update myrank:
## Set all values to 0 
UPDATE movie SET myrank=0;

SELECT * FROM movie;

##Go back to safe mode
SET sql_safe_updates = 1; 

##Set myrank = 9 for the movie title 'Oppenheimer'
UPDATE movie 
SET myrank=9
WHERE title = "Oppenheimer";

#Change the myrank value for 'Oppenheimer' to a different value of your choice
UPDATE movie
SET myrank = 100
WHERE title = "oppenheimer";

SELECT * FROM MyfirstDB.movie;

#E7: Delete Tuples and Attributes
#7.1 Delete the attribute myrank from the movie relation
ALTER TABLE movie
DROP myrank;

SELECT * FROM movie;

#7.2 Delete all tuples from the following relations
##actor
##mcast

DELETE FROM actor;
DELETE FROM mcast; #run this first since it's a foreign key.
SET SQL_SAFE_UPDATES = 0;

#7.4 Delete specific tuples
## From movie table, delete tuples where release_year is 1957
DELETE FROM movie 
WHERE release_year = 1957;
SELECT * FROM mcast
## From mcast table, delete tuples where actor ID is 2
DELETE FROM mcast
WHERE aid = 2;

