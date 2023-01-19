/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(100),
	date_of_birth DATE,
	escape_attempts INT,
	neutered BOOLEAN,
	weight_kg DECIMAL
);

-- Update the table to have a new column with varchar data-type
ALTER TABLE animals 
ADD COLUMN species varchar(255);

-- Create Owners Table
CREATE TABLE owners(
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name TEXT,
	age INT,
	PRIMARY KEY(id)
);

-- Create Species Table
CREATE TABLE species(
	id INT GENERATED ALWAYS AS IDENTITY,
	name TEXT,
	PRIMARY KEY(id)
);

-- Modify animals table

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INT;
ADD COLUMN owner_id INT;

ALTER TABLE animals
ADD FOREIGN KEY(species_id)
	REFERENCES species(id);

ALTER TABLE animals
ADD FOREIGN KEY(owner_id)
	REFERENCES owners(id);
