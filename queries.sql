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

/* queries to answer questions */

-- 1. Animals that belong to Melody Pond

SELECT name AS Melodys_animals FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name LIKE 'Melody%';

-- 2. Animals that are pokemon species

SELECT a.name AS pokemon_animals FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- 3. List of all owners and their animals

SELECT full_name AS owner, name AS animal FROM animals a
RIGHT JOIN owners o ON a.owner_id = o.id
ORDER BY full_name;

-- 4. animals count per species

SELECT COUNT(*) AS Pokemon FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

SELECT COUNT(*) AS digimon FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Digimon';

-- 5. list all digimon's owned by Jennifer Orwell

SELECT a.name AS "jennifer's animals" FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- 6. list all animals owned by Dean and who didn't tried to escape

SELECT name AS "Dean's animals" FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name LIKE 'Dean%' AND a.escape_attempts = 0; 

-- 7. who owns the most animals?

SELECT o.full_name AS owned_by, COUNT(a.owner_id) AS max_owned_animals FROM animals a
JOIN owners o ON a.owner_id = o.id
GROUP BY o.full_name
HAVING COUNT(o.id) = (
	SELECT MAX(animals_count) AS max_count
	FROM (
			SELECT a.owner_id,
			COUNT(a.owner_id) AS animals_count 
			FROM animals a
			GROUP BY 1) AS ds
		);