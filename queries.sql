/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-01-01';
SELECT * FROM animals WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = TRUE;
SELECT * FROM animals WHERE NOT name = 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/* Update table inside transaction */

-- Update species column with unspecified then change it back to it default state
BEGIN;

UPDATE animals
SET species = 'unspecified';

ROLLBACK;

-- Update table for all rows that end with 'mon' with 'digimon' and the rest with 'pokemon'
BEGIN;
	UPDATE animals
	SET species = 'digimon'
	WHERE name LIKE '%mon';
	UPDATE animals
	SET species = 'pokemon'
	WHERE species IS NULL;
COMMIT;

-- Remove all records from the table inside a transaction
BEGIN;
	TRUNCATE animals;
ROLLBACK;

-- Remove records for animals born after Jan 1st, 2022 in transaction
BEGIN;
	DELETE FROM animals
	WHERE date_of_birth >= '2022-01-01';
	SAVEPOINT SP1;
	
	UPDATE animals
	SET weight_kg = weight_kg * -1;
	ROLLBACK TO SAVEPOINT SP1;
	
	UPDATE animals
	SET weight_kg = weight_kg * -1
	WHERE weight_kg < 0;
COMMIT;

-- Queries to answer questions for day-2 tasks

SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, MAX(escape_attempts) AS highest_attempt FROM animals
GROUP BY neutered;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01'
GROUP BY species;