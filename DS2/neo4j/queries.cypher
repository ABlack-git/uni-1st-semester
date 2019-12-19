CREATE
	(f1:FAMILY {id: "corleone", name: "The Corleones"}),
	(f2:FAMILY {id: "tattaglia", name: "The Tattaglias"}),
	(f3:FAMILY {id: "barzini", name: "The Barzinis"}),
	(p1:PERSON {id: "vitoc", name: "Vito Corleone"}),
	(p2:PERSON {id: "michc", name: "Michael Corleone"}),
	(p3:PERSON {id: "tomha", name: "Tom Hagen"}),
	(p4:PERSON {id: "fredc", name: "Frederico Corleone"}),
	(p5:PERSON {id: "philt", name: "Philip Tattaglia"}),
	(p6:PERSON {id: "ricct", name: "Riccardo Tattaglia"}),
	(p7:PERSON {id: "fredn", name: "Freddie Nobile"}),
	(p8:PERSON {id: "emiba", name: "Emilio Barzini"}),
	(p9:PERSON {id: "johdo1", name: "John Doe 1"}),
	(p10:PERSON {id: "johdo2", name:"John Doe 2"}),
	(p11:PERSON {id: "johdo3", name:"John Doe 3"}),
	// corleones
	(p1)-[:MEMBER {position: "Don", startYear: 1920, endYear: 1955}]->(f1),
	(p2)-[:MEMBER {position: "Underboss", startYear: 1948, endYear: 1954}]->(f1),
	(p2)-[:MEMBER {position: "Don", startYear: 1955, endYear: 1980}]->(f1),
	(p3)-[:MEMBER {position: "Consigliere", startYear: 1945, endYear: 1964}]->(f1),
	(p4)-[:MEMBER {position: "Capo", startYear: 1946, endYear: 1955}]->(f1),
	(p9)-[:MEMBER {position: "Soldier", startYear: 1946, endYear: 1955}]->(f1),
	// tattaglias
	(p5)-[:MEMBER {position: "Don", startYear:1920, endYear: 1955}]->(f2),
	(p6)-[:MEMBER {position: "Don", startYear:1956, endYear: 1962}]->(f2),
	(p7)-[:MEMBER {position: "Consigliere", startYear: 1940, endYear: 1955}]->(f2),
	(p10)-[:MEMBER {position: "Capo", startYear: 1940, endYear:1960}]->(f2),
	(p11)-[:MEMBER {position: "Soldier", startYear: 1940, endYear: 1950}]->(f2),
	// barzinis
	(p8)-[:MEMBER {position: "Don", startYear: 1934, endYear: 1955}]->(f3),
	// corleonse
	(p1)-[:SUBORDINATE]->(p3),
	(p1)-[:SUBORDINATE]->(p2),
	(p2)-[:SUBORDINATE]->(p3),
	(p2)-[:SUBORDINATE]->(p4),
	(p4)-[:SUBORDINATE]->(p9),
	// tattaglias
	(p5)-[:SUBORDINATE]->(p7),
	(p5)-[:SUBORDINATE]->(p10),
	(p10)-[:SUBORDINATE]->(p11);

// *********** QUERIES *********** //

// find all members for all families
MATCH (p:PERSON)-[m:MEMBER]->(f:FAMILY) 
RETURN p.name, m.position, m.startYear, m.endYear, f.name
ORDER BY f.name, m.startYear ASC, m.endYear ASC, p.name;

// find all consiglieries of all families
MATCH (f:FAMILY) 
OPTIONAL MATCH (p:PERSON)-[m:MEMBER {position: "Consigliere"}]->(f) 
RETURN f.name, m.position, m.startYear, m.endYear, p.name;

// find all people who were members of a family between 1949 and 1954 
MATCH (f:FAMILY)<-[m:MEMBER]-(p:PERSON) 
	WHERE 1949>m.startYear and 1954<m.endYear 
RETURN f.name, p.name, m.position, m.startYear, m.endYear;

//get number of members of a family between 1949 and 1954
MATCH (f:FAMILY)<-[m:MEMBER]-(p:PERSON) 
	WHERE 1949>m.startYear and 1954<m.endYear 
WITH f,count(distinct p) as members 
RETURN f.name, members;

// Count number of subordinates of a person when this person occupied some position 
MATCH (p1:PERSON)-[m1:MEMBER]->(f:FAMILY)
MATCH (p1)-[s:SUBORDINATE *]->(p2:PERSON) 
MATCH (p2)-[m2:MEMBER]->(f) 
	WHERE p1<>p2 and m2.startYear<m1.endYear and m2.endYear>m1.startYear
WITH p1,f,m1, count(s) as subNum
RETURN p1.name, f.name, m1.position, m1.startYear, m1.endYear, subNum
ORDER BY f.name, subNum DESC;
