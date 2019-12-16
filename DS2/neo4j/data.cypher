// police database containing information about Italian mafia families and their members
CREATE
	(f1:FAMILY {id: "corleone", name: "The Corleones"}),
	(f2:FAMILY {id: "tattaglia", name: "The Tattaglias"}),
	(f3:FAMILY {id: "barzini", name: "The Barzinis"}),
	(p1:PERSON {id: "vitoc", name: "Vito Corleone"}),
	(p2:PERSOM {id: "michc", name: "Michael Corleone"}),
	(p3:PERSON {id: "tomha", name: "Tom Hagen"}),
	(p4:PERSON {id: "fredc", name: "Frederico Corleone"}),
	(p5:PERSON {id: "philt", name: "Philip Tattaglia"}),
	(p6:PERSON {id: "ricct", name: "Riccardo Tattaglia"}),
	(p7:PERSON {id: "fredn", name: "Freddie Nobile"}),
	(p1)-[:MEMBER {position: "Don", startYear: 1920, endYear: 1955}]->(f1),
	(p2)-[:MEMBER {position: "Underboss", startYear: 1955, endYear: 1980}]->(f1),
	(p2)-[:MEMBER {position: "Don", startYear: 1955, endYear: 1980}]->(f1),
	(p3)-[:MEMBER {position: "Consigliere", startYear: 1945, endYear: 1964}]->(f1),
	(p4)-[:MEMBER {position: "Capo", startYear: 1946, endYear: 1955}]->(f1),
	(p5)-[:MEMBER {position: "Don", startYear:, endYear:}]->(f2),
	(p6)-[:MEMBER {position: "Don", startYear:, endYear:}]->(f2),
	(p7)-[:MEMBER {position: "Consigliere", startYear:, endYear:}]->(f2),

	//create some don that is not don in certain period of time to use in opt match
	
	
	