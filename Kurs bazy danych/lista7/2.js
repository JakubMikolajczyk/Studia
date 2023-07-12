use Library
db.createCollection("Books")
db.createCollection("Readers")
show collections

db.Books.insert({
    _id: 1,
    ISBN: "fdgf",
    Tittle: "ghgf",
    Author: "tdhert",
    Year: 2006,
    Price: 13,
    Specimens: [  
        {
            Signature: "S0001"
        }
    ]
})

db.Books.insert({
    _id: 2,
    ISBN: "gefhgr",
    Tittle: "fsgsd",
    Autor: "fah",
    Year: 2007,
    Price: 34,
    Specimens: [
        {
            Signature: "S0002"
        },
        {
            Signature: "S0003"
        }
    ]
})


db.Readers.insert({
    _id: 1,
    Surname: "fsgdf",
    PESEL: 2354354231,
    City: "Wroclaw",
    BirthDate: new Date("1955-10-10"),
    LastBorrow: new Date("2023-02-01"),
    Borrowings: [
        {   
            Signature: "S0002",
            Date: new Date("2023-02-01"),
            days: 14,
        },
        {   
            Signature: "S0001",
            Date: new Date("2023-12-01"),
            days: 54,
        }
    ]
})

db.Readers.insert({
    _id: 2,
    Surname: "dgfhs",
    PESEL: 014323252352523,
    City: "Warszawa",
    BirthDate: new Date("1960-10-10"),
    LastBorrow: new Date("2023-02-01"),
    Borrowings: [
        {   
            Signature: "S0001",
            Data: new Date("2023-02-01"),
            days: 6,
        },
        {   
            Signature: "S0003",
            Data: new Date("2023-01-15"),
            days: 1,
        }
    ]
})

