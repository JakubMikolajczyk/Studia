#include "head.h"
#include <iostream>

int mul5(int x){
    return x * 5;
}

int add20(int x){
    return x + 20;
}

void z1(){

    auto compose = [] (auto g, auto h){
        return [=](auto x){
            return g(h(x));
        };
    };

    auto test = compose(mul5, add20);

    std::cout<<test(0)<<"\n";
    std::cout<<test(2)<<"\n";

    auto test2 = compose(compose(add20, add20), add20);
    std::cout<<test2(2)<<"\n";
}