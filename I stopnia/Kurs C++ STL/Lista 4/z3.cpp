#include "head.h"

#include <iostream>
#include <vector>
#include <set>
#include <list>
#include <string>

#define nl std::cout<<"\n"


template<typename T>
struct Avg {
    T sum;
    int n{0};

    void operator()(T x) {
        sum += x;
        n++;
    }

    void print() {
        std::cout << "Avg: " << sum / n;
    }
};



void z3() {

    auto vec = std::vector<double>{12.5, 156.25, 1.54, 0.0, 1534.6, 75.2, 3.4, 7.52, 6572.67};
    auto lst = std::list<std::string>{"agb", "2fd", "32fgds", "s4g", "43g", "dht", "sdh"};
    auto set = std::set<int>{14, 54, 2, 6, 1, 68, 54, 76, 3, 1, 43};


    std::cout<<"A:"; nl;
    {
        auto filter = [](auto a, auto b) {
            return [=](auto x) {
                if (x > a && x < b)
                    std::cout << x << " ";
            };
        };

        std::for_each(vec.begin(), vec.end(), filter(1.4, 20));
        nl;
        std::for_each(lst.begin(), lst.end(), filter("a", "z"));
        nl;
        std::for_each(set.begin(), set.end(), filter(10, 100));
        nl;
    }

    nl; nl;
    std::cout<<"B:";
    nl;
    {
        auto kidx = [](int p, int k){
            int c = 0;
            return [=] (auto x) mutable {
                if (c >= p && (c % k == 0))
                    std::cout << x << " ";
                c++;
            };
        };

        std::for_each(vec.begin(), vec.end(), kidx(3, 2));
        nl;
        std::for_each(lst.begin(), lst.end(), kidx(5, 1));
        nl;
        std::for_each(set.begin(), set.end(), kidx(1, 4));
        nl;
    }
    nl; nl;

    std::cout<<"C1:"; nl;

    {
        std::for_each(vec.begin(), vec.end(), Avg<double>()).print();
        nl;
        std::for_each(set.begin(), set.end(), Avg<int>()).print();
        nl;
    }
    nl; nl;
    std::cout<<"C2:"; nl;
    {
        double dsum = 0;
        int n = 0;
        std::for_each(vec.begin(), vec.end(), [&dsum, &n](auto x)mutable {
            dsum += x;
            n++;
        });
        std::cout << dsum / n;
        nl;

        int isum = 0;
        n = 0;
        std::for_each(set.begin(), set.end(), [&isum, &n](auto x) mutable {
            isum += x;
            n++;
        });
        std::cout << isum / n;
        nl;
    }

    nl; nl;
    std::cout<<"D:"; nl;

    {
        {
            auto min = vec.begin();
            auto max = vec.begin();

            auto minmax = [&min, &max](auto it) {
                if (*it < *min)
                    min = it;
                if (*it > *max)
                    max = it;
            };

            for (auto it = vec.begin(); it != vec.end(); it++)
                minmax(it);

            std::cout << "Min: " << *min << " Max:" << *max;
            nl;
        }

        {
            auto min = lst.begin();
            auto max = lst.begin();

            auto minmax = [&min, &max](auto it) {
                if (*it < *min)
                    min = it;
                if (*it > *max)
                    max = it;
            };

            for (auto it = lst.begin(); it != lst.end(); it++)
                minmax(it);

            std::cout << "Min: " << *min << " Max:" << *max;
            nl;
        }

        {
            auto min = set.begin();
            auto max = set.begin();

            auto minmax = [&min, &max](auto it) {
                if (*it < *min)
                    min = it;
                if (*it > *max)
                    max = it;
            };

            for (auto it = set.begin(); it != set.end(); it++)
                minmax(it);

            std::cout << "Min: " << *min << " Max:" << *max;
            nl;
        }
    }

    nl; nl;
    std::cout<<"E:"; nl;

    {
        double dsum = 0;
        std::for_each(vec.begin(), vec.end(), [&dsum](auto x) { dsum += x; });
        std::cout << dsum;
        nl;

        std::string ssum = "";
        std::for_each(lst.begin(), lst.end(), [&ssum](auto x) { ssum += x; });
        std::cout << ssum;
        nl;

        int isum = 0;
        std::for_each(set.begin(), set.end(), [&isum](auto x) { isum += x; });
        std::cout << isum;
        nl;
    }

}