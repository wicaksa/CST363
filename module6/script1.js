// Student: Wicaksa Munajat
// Class: CST 363 Intro into DB Structures
// Date: 06/08/2021
// School: CSUMB CS Online/Summer '21
// Assignment: Module 6 MongoDB Script1

// •	Familiarize yourself with mongodb shell commands to insert, retrieve,
//      update and delete documents.
// 1.	Using the insert method, create 3 documents in a collection named “patients”.
//      Each patient document has attributes: name, ssn, age, address.
//      Patients ages should be 10, 20 and 30.
// 2.	The patient with age 30 has a list of prescriptions
//      prescriptions : [
//                 { id: "RX743009", tradename : "Hydrochlorothiazide"   },
//                 { id : "RX656003", tradename : "LEVAQUIN", formula : "levofloxacin"}]

db.patients.drop();
db.patients.insertOne({
    ssn: "111-11-1111",
    name: "Jack",
    age: 10,
    address: "142 Cahill Park Drive San Jose CA, 95126"
});
db.patients.insertOne({
    ssn: "222-22-2222",
    name: "Lucy",
    age: 20,
    address: "212 Summerside Drive San Jose CA, 95126"
});
db.patients.insertOne({
    ssn: "333-33-3333",
    name: "Steve",
    age: 30,
    address: "829 Archer Street Monterey CA, 93940",
    prescriptions: [{
            id: "RX743009",
            tradename: "Hydrochlorothiazide"
        },
        {
            id: "RX656003",
            tradename: "LEVAQUIN",
            formula: "levofloxacin"
        }
    ]
});
// 3.	Retrieve and list all patient data.
cursor = db.patients.find();
print("Displaying all patient data:");
while (cursor.hasNext()) {
    printjson(cursor.next())
};
// 4.	Retrieve the patient document whose age is equal to 20.
cursor = db.patients.find({
    age: 20
});
print("Displaying all patient data whose age is equal to 20:");
while (cursor.hasNext()) {
    printjson(cursor.next())
};
// 5.	Retrieve the patients where age is less than 25.
cursor = db.patients.find({
    age: {
        $lte: 25
    }
});
print("Displaying patients whose younger than 25:");
while (cursor.hasNext()) {
    printjson(cursor.next())
};
// 6.	Using the drop method to delete the entire collection.
db.patients.drop();
