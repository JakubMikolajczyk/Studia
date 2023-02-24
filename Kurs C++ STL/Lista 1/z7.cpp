#include "head.h"


void z7() {

    std::string day, month, year;
    std::cin >> day >> month >> year;
    std::string b;
    switch (int a = std::stoi(month); a) {
        case 1:
            b = "January";
            break;
        case 2:
            b = "February";
            break;
        case 3:
            b = "March";
            break;
        case 4:
            b = "April";
            break;
        case 5:
            b = "May";
            break;
        case 6:
            b = "June";
            break;
        case 7:
            b = "July";
            break;
        case 8:
            b = "August";
            break;
        case 9:
            b = "September";
            break;
        case 10:
            b = "October";
            break;
        case 11:
            b = "November";
            break;
        case 12:
            b = "December";
            break;
    }

    std::cout<<day<<" "<<b<<" "<<year;

}