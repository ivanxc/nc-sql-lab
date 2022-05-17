CREATE TABLE office
(
	office_location text PRIMARY KEY
);

CREATE TABLE team
(
	team_code varchar(16) PRIMARY KEY
);

CREATE TABLE employee
(
	employee_code varchar(16) PRIMARY KEY,
	first_name varchar(32) NOT NULL,
	surname varchar(32) NOT NULL,
	position varchar(64) NOT NULL,
	salary int CHECK (salary > 0),
	office_location text REFERENCES office(office_location),
	team_code varchar(16) REFERENCES team(team_code)
);

CREATE TABLE customer
(
	customer_code varchar(16) PRIMARY KEY,
	customer_name varchar(128)
);

CREATE TABLE project
(
	project_id int PRIMARY KEY,
	customer_code varchar(16) REFERENCES customer(customer_code),
	team_code varchar(16) REFERENCES team(team_code),
	budget int CHECK(budget > 0),
	deadline timestamp NOT NULL
);