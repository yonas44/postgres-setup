
-- Day-2 Create a schema from a diagram

CREATE DATABASE clinic;

CREATE TABLE medical_histories(
	id INT GENERATED ALWAYS As IDENTITY,
	admitted_at TIMESTAMP,
	patient_id INT,
	status VARCHAR,
	PRIMARY KEY(id),
	CONSTRAINT FK_patient_id FOREIGN KEY(patient_id) REFERENCES patients(id)
);


CREATE TABLE treatments(
	id INT GENERATED ALWAYS As IDENTITY,
	type VARCHAR,
	name VARCHAR,
	PRIMARY KEY(id)
);

CREATE TABLE invoice_items(
	id INT GENERATED ALWAYS As IDENTITY,
	unit_price DECIMAL,
	quantity INT,
	total_price DECIMAL,
	invoice_id INT,
	treatment_id INT,
	PRIMARY KEY(id),
	CONSTRAINT FK_treatment_id 
				FOREIGN KEY(treatment_id) 
					REFERENCES treatments(id),
	CONSTRAINT	FK_invoice_id 
				FOREIGN KEY(invoice_id) 
					REFERENCES invoices(id)
);

CREATE TABLE invoices(
	id INT GENERATED ALWAYS As IDENTITY,
	total_amount DECIMAL,
	generated_at TIMESTAMP,
	payed_at TIMESTAMP,
	medical_history_id INT,
	PRIMARY KEY(id),
	CONSTRAINT FK_medical_history_id FOREIGN KEY(medical_history_id) REFERENCES medical_histories(id)
);

CREATE TABLE patients(
	id INT GENERATED ALWAYS As IDENTITY,
	name VARCHAR,
	date_of_birth DATE,
	PRIMARY KEY(id)
);

CREATE TABLE medical_treatment_histories (
    md_history_id INT REFERENCES medical_histories(id),
    treatment_id INT REFERENCES treatments(id)
);

-- Add indexes for optimized query performance

CREATE INDEX FK_patient_id_index ON medical_histories(patient_id);
CREATE INDEX FK_treatment_id_index ON invoice_items(treatment_id);
CREATE INDEX FK_invoice_id_index ON invoice_items(invoice_id);
CREATE INDEX FK_md_history1_id_index ON invoices(medical_history_id);
CREATE INDEX FK_md_history_id2_index ON medical_treatment_histories(md_history_id);
CREATE INDEX FK_treatment_id2_index ON medical_treatment_histories(treatment_id);