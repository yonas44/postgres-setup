/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Agumon', '2020-02-03', 10.23, true, 0);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Gabumon', '2018-11-15', 8.0, true, 2);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Pikachu', '2021-01-07', 15.04, false, 1);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Devimon', '2017-05-12', 11.0, true, 5);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Charmander', '2020-02-08', -11.0, false, 0);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Plantmon', '2021-11-15', -5.7, true, 2);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Squirtle', '1993-04-02', -12.13, false, 3);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Angemon', '2005-06-12', -45.0, true, 1);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Boarmon', '2005-06-07', 20.4, true, 7);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Blossom', '1998-10-13', 17.0, true, 3);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Ditto', '2022-03-14', 22.0, true, 4);

-- Insert data to owners table

INSERT INTO owners(full_name, age) VALUES('Sam Smith', 34);
INSERT INTO owners(full_name, age) VALUES('Jennifer Orwell', 19);
INSERT INTO owners(full_name, age) VALUES('Bob', 45);
INSERT INTO owners(full_name, age) VALUES('Melody Pond', 77);
INSERT INTO owners(full_name, age) VALUES('Dean Winchester', 14);
INSERT INTO owners(full_name, age) VALUES('Jodie Whittaker', 38);


-- Insert data to species table

INSERT INTO species(name) VALUES('Pokemon');
INSERT INTO species(name) VALUES('Digimon');

-- Modify animals table so it includes the species_id value

UPDATE animals
SET species_id = 1
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = 2
WHERE species_id IS NULL;

-- Modify animals table so it includes the owner_id value

UPDATE animals
SET owner_id = 1
WHERE name = 'Agumon';

UPDATE animals
SET owner_id = 2
WHERE name IN ('Gabumon', 'Pikachu');

UPDATE animals
SET owner_id = 3
WHERE name IN ('Devimon', 'Plantmon');

UPDATE animals
SET owner_id = 4
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

UPDATE animals
SET owner_id = 5
WHERE name IN ('Angemon', 'Boarmon');

/* DAY-4 */

-- 1. Insert data to vets table

INSERT INTO vets(name, age, date_of_graduation) 
VALUES ('William Tatcher', 45, '2000-04-23'),
		('Maisy Smith', 26, '2019-01-17'),
		('Stephanie Mendez', 64, '1981-05-04'),
		('Jack Harkness', 38, '2008-06-08');

-- 2. Insert data to specialization table

INSERT INTO specialization(vet_id, species_id)
VALUES (
			(SELECT id FROM vets v WHERE v.name = 'William Tatcher'), 
			(SELECT id FROM species s WHERE s.name = 'Pokemon')
		),
		(
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			(SELECT id FROM species s WHERE s.name = 'Pokemon')
		),
		(
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			(SELECT id FROM species s WHERE s.name = 'Digimon')
		),
		(
			(SELECT id FROM vets v WHERE v.name = 'Jack Harkness'), 
			(SELECT id FROM species s WHERE s.name = 'Digimon')
		);

-- 3. Insert data to visits table
-- NOTE: Here we could use the id's of the animals and vets explicitly but instead I used query to select the id which I believe will be beneficial when working with huge databases.

INSERT INTO visits(animals_id, vet_id, visited_on)
VALUES (
			(SELECT id FROM animals a WHERE a.name = 'Agumon'),
			(SELECT id FROM vets v WHERE v.name = 'William Tatcher'), 
			'2020-05-24'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Agumon'),
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			'2020-07-22'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Gabumon'),
			(SELECT id FROM vets v WHERE v.name = 'Jack Harkness'), 
			'2021-02-02'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Pikachu'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2020-01-05'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Pikachu'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2020-03-08'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Pikachu'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2020-05-14'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Devimon'),
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			'2021-05-04'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Charmander'),
			(SELECT id FROM vets v WHERE v.name = 'Jack Harkness'), 
			'2021-02-24'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Plantmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2019-12-21'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Plantmon'),
			(SELECT id FROM vets v WHERE v.name = 'William Tatcher'), 
			'2020-08-10'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Plantmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'202-04-07'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Squirtle'),
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			'2019-09-29'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Angemon'),
			(SELECT id FROM vets v WHERE v.name = 'Jack Harkness'), 
			'2020-10-03'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Angemon'),
			(SELECT id FROM vets v WHERE v.name = 'Jack Harkness'), 
			'2020-11-04'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Boarmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2019-01-24'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Boarmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2019-05-15'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Boarmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2020-02-27'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Boarmon'),
			(SELECT id FROM vets v WHERE v.name = 'Maisy Smith'), 
			'2020-08-03'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Blossom'),
			(SELECT id FROM vets v WHERE v.name = 'Stephanie Mendez'), 
			'2020-05-24'
		),
		(
			(SELECT id FROM animals a WHERE a.name = 'Blossom'),
			(SELECT id FROM vets v WHERE v.name = 'William Tatcher'), 
			'2021-01-11'
		);