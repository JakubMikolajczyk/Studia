#include "head.h"
#include <iostream>

void printn(int n) {
    std::cout << n<<" ";
}

void printadd5(int n) {
    std::cout << n + 5<<" ";
}

void mul2(int n){
    std::cout<< 2 *n<<" ";
}

void z2() {
    auto po_kolei = [](auto f1, auto f2) {
        return [=](auto x) {
            f1(x);
            f2(x);
        };
    };

    po_kolei(po_kolei(po_kolei(printadd5, printn), mul2), mul2)(12);
}