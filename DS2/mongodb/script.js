db.createCollection("cases");
db.createCollection("people");
// ----------- INSERT CASES ----------- //
db.cases.insert(
{
    "_id": "1978-03-12/1",
    "date": {
      "year": 1978,
      "month": 3,
      "day": 12
    },
    "victims": [
      {
        "name": {
          "first": "John1",
          "last": "Doe1"
        },
        "contacts": {
          "mobile": "555-111-111"
        }
      }
    ],
    "suspects": [
      "ledbea"
    ],
    "crimeType": "ROBBERY",
    "status": "CLOSED"
}
);

db.cases.insert(
{
    "_id": "2001-04-12/1",
    "date": {
      "year": 2001,
      "month": 4,
      "day": 12
    },
    "victims": [
      {
        "name": {
          "first": "John2",
          "last": "Doe2"
        },
        "contacts": {
          "mobile": "555-111-222",
          "home": "221B Baker Street"
        }
      },
      {
        "name": {
          "first": "Jane1",
          "last": "Doe2"
        },
        "contacts": {
          "mobile": "555-222-111",
          "home": "221B Baker Street"
        }
      }
    ],
    "suspects": [
      "taylan",
      "colhen"
    ],
    "crimeType": "ASSAULT",
    "status": "CLOSED"
  }
);

db.cases.insert(
{
    "_id": "2002-11-23/1",
    "date": {
      "year": 2002,
      "month": 11,
      "day": 23
    },
    "victims": [
      {
        "name": {
          "first": "John3",
          "last": "Doe3"
        },
        "contacts": {
          "mobile": "555-111-333"
        }
      },
      {
        "name": {
          "first": "John4",
          "last": "Doe4"
        },
        "contacts": {
          "mobile": "555-111-444"
        }
      },
      {
        "name": {
          "first": "John5",
          "last": "Doe5"
        },
        "contacts": {
          "mobile": "555-111-555"
        }
      }
    ],
    "suspects": [
      "antspi",
      "colhen"
    ],
    "crimeType": "ASSAULT",
    "status": "CLOSED"
  }
);

db.cases.insert(
{
    "_id": "1989-05-27/1",
    "date": {
      "year": 1989,
      "month": 5,
      "day": 27
    },
    "victims": [
      {
        "name": {
          "first": "John6",
          "last": "Doe6"
        },
        "contacts": {
          "mobile": "555-111-666"
        }
      },
      {
        "name": {
          "first": "John7",
          "last": "Doe7"
        },
        "contacts": {
          "mobile": "555-111-777"
        }
      }
    ],
    "suspects": [],
    "crimeType": "MURDER",
    "linkedCases": [
      "1999-12-1/1"
    ],
    "status": "OPEN"
  }
);

db.cases.save(
{
    "_id": "1999-12-1/1",
    "date": {
      "year": 1999,
      "month": 12,
      "day": 1
    },
    "victims": [
      {
        "name": {
          "first": "John1",
          "last": "Doe1"
        },
        "contacts": {
          "mobile": "555-111-111"
        }
      }
    ],
    "crimeType": "MURDER",
    "linkedCases": [
      "1989-05-27/1"
    ],
    "status": "OPEN"
  }
);
// ----------- INSERT PEOPLE ----------- //

db.people.save(
{
    "_id": "antspi",
    "name": {
      "first": "Spike",
      "last": "Anthony"
    },
    "dateOfBirth": {
      "year": 1971,
      "month": 6,
      "date": 26
    },
    "gender": "M",
    "casesInvolved": [
      "2002-11-23/1"
    ],
    "crimeHistory": [
      {
        "crimeType": "ASSAULT",
        "convictionDate": {
          "year": 1981,
          "month": 5,
          "day": 30
        }
      },
      {
        "crimeType": "ROBBERY",
        "convictionDate": {
          "year": 1984,
          "month": 3,
          "day": 25
        }
      }
    ]
  }
);

db.people.save(
{
    "_id": "taylan",
    "name": {
      "first": "Landon",
      "last": "Taylor",
      "middle": "Jeremy"
    },
    "dateOfBirth": {
      "year": 1965,
      "month": 7,
      "date": 17
    },
    "gender": "M",
    "casesInvolved": [
      "2001-04-12/1"
    ],
    "crimeHistory": [
      {
        "crimeType": "ASSAULT",
        "convictionDate": {
          "year": 1991,
          "month": 1,
          "day": 9
        }
      },
      {
        "crimeType": "MURDER",
        "convictionDate": {
          "year": 2005,
          "month": 9,
          "day": 1
        }
      }
    ]
  }
);

db.people.save(
{
    "_id": "colhen",
    "name": {
      "first": "Henry",
      "last": "Collins"
    },
    "dateOfBirth": {
      "year": 1972,
      "month": 10,
      "date": 11
    },
    "gender": "M",
    "casesInvolved": [
      "2002-11-23/1",
      "2001-04-12/1"
    ],
    "crimeHistory": [
      {
        "crimeType": "ROBBERY",
        "convictionDate": {
          "year": 1991,
          "month": 12,
          "day": 22
        }
      },
      {
        "crimeType": "ROBBERY",
        "convictionDate": {
          "year": 1999,
          "month": 1,
          "day": 12
        }
      }
    ]
  }
);

db.people.save(
{
    "_id": "wesmar",
    "name": {
      "first": "Mary",
      "last": "Wesley"
    }
  }
);

// ----------- UPDATE ----------- //

db.people.update(
 {"_id": "wesmar"},
 {
    "name": {
          "first": "Mary",
          "last": "Wesley"
        },
    "dateOfBirth": {
          "year": 1955,
          "month": 1,
          "date": 1
        },
    "gender": "F",
    "crimeHistory": [
      {
        "crimeType": "MURDER",
        "convictionDate": {
          "year": 1974,
          "month": 7,
          "day": 17
        }
      }
    ]}
);

db.people.update(
    {"_id": "taylan"},
    {$push: {
        "crimeHistory":{
            "crimeType": "ASSAULT",
            "convictionDate": {
              "year": 1986,
              "month": 9,
              "day": 9
            }
         }
      },
      $set: {"dateOfBirth.month": 8}
     }
);

db.people.update(
    {"_id": "ledbea"},
    {
        "name": {
          "first": "Beatrice",
          "last": "Ledford"
        },
        "dateOfBirth": {
          "year": 1981,
          "month": 4,
          "date": 21
        },
        "gender": "F",
        "casesInvolved": [
          "1978-03-12/1"
        ]
  },
  {upsert: true}
)

// ----------- FIND ----------- //
/// find all females and show only their name
db.people.find({"gender":"F"}, {_id:0, name:1}).forEach(printjson);
// find all cases that are still opened and the year when they were opened is less than 2000
db.cases.find({$and: [{status: "OPEN"}, {"date.year": {$lt: 2000}}]}, {status:1, "date.year":1, crimeType:1}).forEach(printjson);
// find all cases where victim is John1 Doe1
db.cases.find({"victims": {$elemMatch: {"name.first": "John1", "name.last": "Doe1"}}}, {"victims.name":1, crimeType:1}).forEach(printjson);
// find all people who have previous record of ASSAULT or ROBBERY and sort them by date of birth in ascending order
db.people.find({$or: [{"crimeHistory.crimeType": "ASSAULT"}, {"crimeHistory.crimeType": "ROBBERY"}]},
{"crimeHistory.crimeType":1, "dateOfBirth.year":1}).sort({"dateOfBirth.year":1}).forEach(printjson);
// find all cases without suspect
db.cases.find({$or: [{"suspects": {$exists: false}}, {"suspects": {$size: 0}}] }, {_id:1, suspects:1}).forEach(printjson);
// ----------- MAP REDUCE ----------- //
/*
Count number of victims for each crimeType
(key, values): key is crimeType, values is array containing number of victims per document, e.g ASSAULT: [2,3]
Reducer output: _id is crimeType, value is total number of victims of this crimeType
*/
db.cases.mapReduce(
    function() { emit(this.crimeType, this.victims.length) },
    function(key, values) { return Array.sum(values) },
    {
        out: {inline: 1}
    }
);