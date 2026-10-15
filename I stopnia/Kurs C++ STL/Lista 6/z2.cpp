//#include "head.h"

#include <iostream>
#include <algorithm>
#include <list>

#define nl std::cout<<"\n"
#define nl3 std::cout<<"\n\n\n"

enum quarter {
    first,
    second,
    third,
    fourth,
    none
};

struct RGB {
    int x;
    int y;
    std::string name;
    int R;
    int G;
    int B;

    RGB(int x, int y, const std::string &name, int r, int g, int b) : x(x), y(y), name(name), R(r), G(g), B(b) {}

    double ilum() const {
        return 0.3 * R + 0.59 * G + 0.11 * B;
    }

    friend std::ostream &operator<<(std::ostream &os, const RGB &rgb) {
        os << "x: " << rgb.x << " y: " << rgb.y << " name: " << rgb.name << " R: " << rgb.R << " G: " << rgb.G << " B: "
           << rgb.B;
        os << " Ilum: " << rgb.ilum();
        return os;
    }


    quarter getQuarter() const {
        if (x > 0 && y > 0) return quarter::first;
        if (x < 0 && y > 0) return quarter::second;
        if (x < 0 && y < 0) return quarter::third;
        if (x > 0 && y < 0) return quarter::fourth;

        return quarter::none;
    }

};

void print(auto itBegin, auto itEnd) {
    std::for_each(itBegin, itEnd, [](auto x) {
        std::cout << x;
        nl;
    });
}


int main() {

    auto list = std::list<RGB>{
            RGB(334, -323, "df", 13, 11, 227),
            RGB(121, 12, "ad", 30, 30, 222),
            RGB(32, -347, "gtrt", 162, 141, 121),
            RGB(50, -6, "regregf", 21, 13, 132),
            RGB(-11, 345, "regre", 16, 2, 25),
            RGB(-2, 237, "asfsdg", 5, 147, 1),
            RGB(-3, 3, "egrhty", 0, 0, 0),
            RGB(-44, -53, "asfsfgdt", 1, 120, 152),
            RGB(-6, -13, "savbf gfht", 14, 241, 117),
            RGB(-82, 32, "safvdsgr", 11, 223, 117),
            RGB(-58, 31, "aefdsgh", 15, 32, 124),
            RGB(15, 33, "asd213r2e", 133, 5, 231),
            RGB(7, -35, "fas32rqef", 129, 116, 102),
            RGB(61, -56, "fasd4523rwfe", 12, 231, 10),
            RGB(0, 0, "dfs32rwe", 172, 15, 21),
            RGB(-3, 2, "dsf3tt2", 31, 45, 11),
            RGB(13, 1, "dsf32t", 127, 17, 53),
    };

    std::cout << "A:\n";

    list.remove_if([](auto x) {
        return x.name.length() > 5;
    });


    print(list.begin(), list.end());
    nl3;

    std::cout << "B:\n";

    unsigned int first = 0, second = 0, third = 0, fourth = 0, none = 0;

    std::for_each(list.begin(), list.end(), [&](auto x) {
        switch (x.getQuarter()) {
            case quarter::first:
                first++;
                break;
            case quarter::second:
                second++;
                break;
            case quarter::third:
                third++;
                break;
            case quarter::fourth:
                fourth++;
                break;
            case quarter::none:
                none++;
                break;
        }
    });

    std::cout << "First: " << first << " Second: " << second << " Third: " << third << " Fourth: " << fourth << " None: "
              << none;


    nl3;
    std::cout << "C:\n";
    list.sort([](auto a, auto b) {
        return a.ilum() > b.ilum();
    });

    print(list.begin(), list.end());

    std::cout << "D:\n";
    auto newlist = std::list<RGB>();
    auto partIt = std::partition(list.begin(), list.end(), [](auto x) {
        return x.ilum() < 64;
    });

    newlist.splice(newlist.end(), list, partIt, list.end());

    print(newlist.begin(), newlist.end());
    nl3;
    print(list.begin(), list.end());
}