// ------------ SCHEMA ------------
CREATE TYPE PERSON (
	id INT,
	firstName TEXT,
	lastName TEXT
);

CREATE TABLE crimes (
	id INT,
	offense TEXT,
	arrestedPersons SET<FROZEN<PERSON>>,
	crimeLocation MAP<TEXT,TEXT>,
	additionalCharges LIST<TEXT>,
	crimeDate DATE,
	PRIMARY KEY (offense, id, crimeDate)
);

CREATE TABLE offenders (
	id INT PRIMARY KEY,
	name TUPLE<TEXT, TEXT>,
	age INT,
	gender TEXT
);

// ------------ INSERTS ------------

INSERT INTO crimes (id, offense, arrestedPersons, crimeLocation, crimeDate, additionalCharges) VALUES 
(
	1, 
	'Bulglary', 
	{{id: 1, firstName: 'John', lastName: 'Doe'}, {id: 2, firstName: 'Jane', lastName: 'Doe'}}, 
	{'district': 'North', 'street': 'Elm', 'postalCode': '17000'}, 
	'2003-03-01',
	['Assault', 'Theft']
);

INSERT INTO crimes (id, offense, arrestedPersons, crimeLocation, crimeDate) VALUES 
(
	2, 
	'Minor Theft', 
	{{id: 3, firstName: 'Paul', lastName: 'Molive'}}, 
	{'district': 'South', 'street': 'Oak', 'postalCode': '18000', 'building': '5'}, 
	'2003-04-01'
);

INSERT INTO crimes (id, offense, arrestedPersons, crimeLocation, crimeDate, additionalCharges) VALUES 
(
	3, 
	'Illegal Drug Trade', 
	{{id: 4, firstName: 'Will', lastName: 'Power'}, {id: 5, firstName: 'Donatella', lastName: 'Nobatti'}}, 
	{'district': 'North-West', 'street': 'Maple', 'postalCode': '19000', 'building'='11'}, 
	'2003-05-01',
	['Illegal Weapon Possesion']
);
INSERT INTO crimes (id, offense, arrestedPersons, crimeLocation, crimeDate, additionalCharges) VALUES 
(
	4, 
	'Bulglary',
	{{id: 6, firstName: 'Minnie', lastName: 'Moocher'}},
	{'district': 'West', 'street': 'Cottonwood', 'postalCode': '11000', 'building': '32'},
	'2003-06-01',
	['Theft', 'Drug Possesion']
);


INSERT INTO offenders (id, name, age, gender) VALUES (1, ('John', 'Doe'),32,'M');
INSERT INTO offenders (id, name, age, gender) VALUES (2, ('Jane', 'Doe'), 33, 'F');
INSERT INTO offenders (id, name, age, gender) VALUES (3, ('Paul', 'Molive'), 21, 'M');
INSERT INTO offenders (id, name, age, gender) VALUES (4, ('Will', 'Power'), 44, 'M');
INSERT INTO offenders (id, name, age, gender) VALUES (5, ('Donatella', 'Nobatti'), 33, 'F');
INSERT INTO offenders (id, name, age, gender) VALUES (6, ('Minnie', 'Moocher'), 19, 'F');
INSERT INTO offenders (id, name, age, gender) VALUES (7, ('Lucas', 'Russo'), 22, 'M');
INSERT INTO offenders (id, name, age, gender) VALUES (8, ('Paul', 'Whittaker'), 31, 'M');

// ------------ UPDATES ------------

// add
UPDATE crimes
SET
	arrestedPersons = arrestedPersons + {{id: 7, firstName: 'Lucas', lastName: 'Russo'}},
	crimeLocation = crimeLocation + {'venue': 'Burger King'},
	additionalCharges = additionalCharges + ['Resisting Arrest', 'Officer Assault']
WHERE id=3 and offense='Illegal Drug Trade' and crimeDate = '2003-05-01';

SELECT * FROM crimes
where id = 3
ALLOW FILTERING;

// remove
UPDATE crimes
SET
	arrestedPersons = arrestedPersons - {{id: 3, firstName: 'Paul', lastName: 'Molive'}},
	crimeLocation = crimeLocation - {'building'},
	additionalCharges = additionalCharges - ['Illegal Weapon Possesion']
WHERE id=3 and offense='Illegal Drug Trade' and crimeDate = '2003-05-01';

SELECT * FROM crimes
where id=3
ALLOW FILTERING;

// replace 
UPDATE crimes
SET
	arrestedPersons = {{id: 8, firstName: 'Paul', lastName: 'Whittaker'}},
	crimeLocation = {'district': 'North-West', 'street': 'Sycamore'},
	additionalCharges = ['Resisting Arrest']
WHERE id=3 and offense='Illegal Drug Trade' and crimeDate = '2003-05-01';

SELECT * FROM crimes
where id = 3
ALLOW FILTERING;

// ------------ SELECTS ------------

SELECT * FROM offenders;

SELECT * FROM offenders
WHERE gender = 'M'
ALLOW FILTERING;

SELECT * FROM crimes
WHERE offense = 'Bulglary'
ORDER BY id DESC, crimeDate DESC;

// ------------ CREATE UNDEX ------------

CREATE INDEX ON offenders (gender);