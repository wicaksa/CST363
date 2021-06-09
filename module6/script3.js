// Student: Wicaksa Munajat
// Class: CST 363 Intro into DB Structures
// Date: 06/08/2021
// School: CSUMB CS Online/Summer '21
// Assignment: Module 6 MongoDB Script3

// Code a script3.js file that does uses map reduce to do a join of the customers
// and orders collections and summarizes the quantity of items sold by zip code.
// Your output should have for each zip code, the count of items sold to customers
// in that zip code.

// customerid in customer = customer in orders (key)
// find how many orders each customer (id) had

mapf1 = function() {
    for (item of this.items) {
        emit(this.customer, item.qty);
    }
};

reducef1 = function(key, values) {
    total = 0;

    for (x of values) {
        total = total + x;
    }

    return {
        "qty": total
    };
}

db.orders.mapReduce(mapf1, reducef1, {
    out: "order_summary"
});

/* debug
cursor = db.order_summary.find();
while (cursor.hasNext()) {
    printjson(cursor.next());
};
*/

// find the zipcode of those customer id
mapf2 = function() {
    address = this.address;
    zip = address.zip;

    emit(this.customerId, {
        "zip": zip
    });
}

reducef2 = function(key, values) {
    value = {
        "zip": 0,
        "qty": 0
    }
    for (x of values) {
        if (x.qty > 0) {
            value.qty = x.qty;
        }
        if (x.zip != 0) {
            value.zip = x.zip;
        }
    }
    return value;
};

db.customers.mapReduce(mapf2, reducef2, {
    out: {
        reduce: "order_summary"
    }
});

/* debug

cursor = db.order_summary.find();
while (cursor.hasNext()) {
    printjson(cursor.next());
};
*/

mapf3 = function() {
    emit(this.value.zip, {
        "qty": this.value.qty
    });
}

reducef3 = function(key, values) {
    total = 0;
    for (x of values) {
        total = total + x.qty;
    }
    return {
        "qty": total
    };
}

db.order_summary.mapReduce(mapf3, reducef3, {
    out: "order_result"
});


cursor = db.order_result.find();
print("Displaying customer id and how quantity of items purchased:");
while (cursor.hasNext()) {
    printjson(cursor.next());
};

//------------------------------------------------------------------------------//