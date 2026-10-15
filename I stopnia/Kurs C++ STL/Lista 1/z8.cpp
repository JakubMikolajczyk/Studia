#include "head.h"
#include <vector>

struct Person{
    Person(const std::string &surname, const std::string &name, int year) : surname(surname), name(name), year(year) {}

    bool operator<(const Person &rhs) const {
        return std::tie(surname, name, year) < std::tie(rhs.surname, rhs.name, rhs.year);
    }

    friend std::ostream &operator<<(std::ostream &os, const Person &person) {
        os << "surname: " << person.surname << " name: " << person.name << " year: " << person.year;
        return os;
    }

    std::string surname;
    std::string name;
    int year;


};

void z8(){
    std::vector<Person> vec {
        {"abc", "aaa", 2001},
        {"abc", "bbb", 2001},
        {"abc", "aaa", 2000},
        {"aaa", "fgdg", 3531},
        {"ccc", "edfs", 4312}};

    std::sort(vec.begin(), vec.end());
    for (const auto& i : vec)
        std::cout<<i<<"\n";
}