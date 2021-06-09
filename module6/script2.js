// Student: Wicaksa Munajat
// Class: CST 363 Intro into DB Structures
// Date: 06/08/2021
// School: CSUMB CS Online/Summer '21
// Assignment: Module 6 MongoDB Script2

// Script 2
// Code a script2.js file that does a map reduce of the customers collections and
// produces a report that shows zip code that start with ‘9’ and the count of
// customers for each zip code.

mapf = function() {
    if (this.address.zip.startsWith("9")) {
        emit(this.address.zip, 1);
    }
}

reducef = function(key, values) {
    total = 0;

    for (x of values) {
        total = total + x;
    }
    return {
        total
    };
}

db.customers.mapReduce(mapf, reducef, {
    out: "zipresult"
});

// Print the reduced collection
cursor = db.zipresult.find();
print("Displaying Zipcodes that start with 9 and their instances:");
while (cursor.hasNext()) {
    printjson(cursor.next());
}