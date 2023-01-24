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

/* DAY-4 */

-- 1. last animal seen by William Tatcher

SELECT ve.name AS vet, a.name AS last_visited_animal, visited_on FROM visits vi
JOIN animals a ON vi.animals_id = a.id
JOIN vets ve ON ve.id = vi.vet_id
GROUP BY ve.name, a.name, visited_on
HAVING vi.visited_on = (
			SELECT MAX(visited_on) FROM visits 
			WHERE vet_id = 1);

-- 2. How many animals did Stephanie Mendez see?

SELECT ve.name, COUNT(*)
FROM ( SELECT vet_id, COUNT(animals_id) AS animal_types FROM visits vi
		WHERE vet_id = 3
		GROUP BY vet_id, animals_id
	 ) AS ds
JOIN vets ve ON ve.id = vet_id
GROUP BY ve.name;

-- 3. List of all vets with/ without speciality

SELECT ve.name AS vet, s.name AS speciality FROM vets ve
LEFT JOIN specialization sp ON ve.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- 4. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020

SELECT a.name, visited_on FROM visits vi
JOIN animals a ON vi.animals_id = a.id
WHERE vet_id = 3 AND visited_on BETWEEN '2020-04-01' AND '2020-08-30';


-- 5. Animal that has most visits to vets

SELECT a.name, COUNT(*) FROM visits vi
JOIN animals a ON vi.animals_id = a.id
GROUP BY a.name
HAVING COUNT(*) = 
	(
		SELECT MAX(ds.max_visit) 
		FROM (
				SELECT COUNT(*) AS max_visit FROM visits vi
		 		GROUP BY animals_id
		 	) AS ds
	);


-- 6. Who was Maisy Smith's first visit?

SELECT a.name, visited_on FROM visits vi
JOIN animals a ON vi.animals_id = a.id
GROUP BY a.name, visited_on
HAVING vi.visited_on = 
(SELECT MIN(visited_on) FROM visits vi 
WHERE vet_id = 2);

-- 7. Details for most recent visit: animal information, vet information, and date of visit

SELECT a.id as animal_id, a.name as animal_name, date_of_birth as animal_date_of_birth, escape_attempts as animal_escape_attempts,
neutered as animal_neutered, weight_kg as animal_weight_kg, species_id as animal_species_id, owner_id as animal_owner_id,
vet_id, ve.name as vet_name, visited_on FROM visits vi
LEFT JOIN animals a ON a.id = vi.animals_id
LEFT JOIN vets ve ON ve.id = vi.vet_id
ORDER BY visited_on DESC
LIMIT 1;

-- 8. How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(ds.treated) 
FROM (
	SELECT vi.vet_id AS vet, sp.species_id AS speciality, a.species_id AS treated FROM visits vi
	LEFT JOIN specialization sp ON sp.vet_id = vi.vet_id
	JOIN animals a ON a.id = vi.animals_id
	WHERE sp.species_id IS NULL
	) AS ds;

-- 9. What specialty should Maisy Smith consider getting?

SELECT s.name AS speciality_should_learn FROM
	(SELECT species_id, COUNT(species_id) AS treatment_count FROM visits vi
	JOIN animals a ON animals_id = a.id
	WHERE vi.vet_id = 2
	GROUP BY species_id
	ORDER BY treatment_count DESC
	LIMIT 1) AS ds
JOIN species s ON ds.species_id = s.id;

------------- /* WEEK 2 Performance demo */ -------------------
-- Day-1

explain analyze SELECT COUNT(*) FROM visits where animals_id = 4;
explain analyze SELECT * FROM visits where vet_id = 2;
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';
