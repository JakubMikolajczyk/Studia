//#include "head.h"

#include <iostream>
#include <deque>
#include <random>

#define nl std::cout<<"\n"
#define nl3 std::cout<<"\n\n\n"

struct person {
    std::string name;
    std::string surname;
    int age;
    float wage;
    float height;

    person(const std::string &name, const std::string &surname, int age, float wage, float height) : name(name),
                                                                                                     surname(surname),
                                                                                                     age(age),
                                                                                                     wage(wage),
                                                                                                     height(height) {}

    float BMI() const {
        return wage / (height * height);
    }

    friend std::ostream &operator<<(std::ostream &os, const person &person) {
        os << "" << person.name << " " << person.surname << " age: " << person.age << " wage: "
           << person.wage << " height: " << person.height;
//        os<<"BMI:"<<person.BMI();
        return os;
    }

    bool operator==(const person &rhs) const {
        return name == rhs.name &&
               surname == rhs.surname &&
               age == rhs.age &&
               wage == rhs.wage &&
               height == rhs.height;
    }

    bool operator!=(const person &rhs) const {
        return !(rhs == *this);
    }
};

void print(auto itBegin, auto itEnd) {
    std::for_each(itBegin, itEnd, [](auto x) {
        std::cout << x;
        nl;
    });
}

static double RandomFloat(double a, double b) {
    float random = ((float) rand() / RAND_MAX);
    float diff = b - a;
    float r = random * diff;
    return r + a;
}

int main() {

    auto deq = std::deque<person>{
        person("Max", "Verstappen", 21, 70, 1.81),
                person("Charles", "Leclerc", 22, 52, 1.58),
                person("Lando", "Norris", 23, 90, 1.43),
                person("Sergio", "Perez", 27, 127, 2.20),
                person("Lewis", "Hamilton", 33, 110, 1.98),
                person("Robert", "Kubica", 35, 87, 1.86),
                person("Mick", "Schumacher", 19, 124, 1.58),
                person("Nick", "de Vries", 27, 68, 1.73),
                person("Daniel", "Riccardo", 30, 52, 1.91),
                person("George", "Russel", 24, 75, 1.75),
                person("Carlos", "Sainz", 27, 130, 1.91)
    };

    std::cout << "A:\n";
    std::sort(deq.begin(), deq.end(), [](auto a, auto b) {
        return a.BMI() > b.BMI();
    });

    print(deq.begin(), deq.end());
    nl3;

    std::cout<<"B:\n";

    std::for_each(deq.begin(), deq.end(), [](auto &x) mutable {
        x.wage *= 0.9;
    });

    print(deq.begin(), deq.end());
    nl3;

    std::cout << "C:\n";

    auto partIt = std::partition(deq.begin(), deq.end(), [](auto x){
        return x.wage > 100;
    });

    print(deq.begin(), partIt);
    nl3;
    print(partIt, deq.end());
    nl3;


    std::cout << "D: \n";


    auto deqcopy = std::deque<person>();
    std::copy(deq.begin(), deq.end(), std::back_inserter(deqcopy));
    std::sort(deqcopy.begin(), deqcopy.end(), [](auto a, auto b){
        return a.height < b.height;
    });

    auto itMid = std::find(deq.begin(), deq.end(), *(deqcopy.begin() + 5));
    std::swap(*itMid, *(deq.begin() + 5));

    print(deq.begin(), deq.end());

    std::cout << "E:\n";

    auto mid = deq.begin() + 5;

    std::random_device rd;
    std::mt19937 g(rd());

    std::shuffle(deq.begin(), mid, g);
    std::shuffle(mid + 1, deq.end(), g);
    print(deq.begin(), deq.end());
    nl3;


    auto a = std::minmax_element(deq.begin(), deq.end(), [](auto a, auto b) {
        return a.age < b.age;
    });

    std::cout << "MIN: " << *a.first << "\nMAX: " << *a.second;
}