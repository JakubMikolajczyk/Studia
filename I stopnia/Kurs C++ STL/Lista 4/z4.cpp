#include "head.h"

#include <iostream>
#include <vector>

void z4() {

    auto print = [](int x) {
        std::cout << x << " ";
    };

    auto fib = [](int& x) {

        const std::function<int(int)> fibrec =
                [&fibrec](int n) {
                    if (n < 0)
                        return 0;
                    if (n == 1 || n == 2)
                        return 1;
                    return fibrec(n - 1) + fibrec(n - 2);
                };


        x = fibrec(x);
    };


    auto vec = std::vector{1, 2, 3, 4, 5, 6, 7, 8, -1, 12};
    std::for_each(vec.begin(), vec.end(), fib);
    std::for_each(vec.begin(), vec.end(), print);

}