#include "head.h"

auto lucas(uint32_t n){
    if (n == 0)
        return  2;
    if (n == 1)
        return 1;
    return lucas(n - 1) + lucas(n - 2);
}

void z5(){
    std::cout<<lucas(5)<<"\n"<<lucas(20);
}