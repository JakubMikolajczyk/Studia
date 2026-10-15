#include <iostream>
#include "limits"

int main(){

    auto llint = std::numeric_limits<long long int>();
    std::cout<<llint.min()<<"\n";
    std::cout<<llint.max()<<"\n";
    std::cout<<llint.digits<<"\n";
    std::cout<<llint.digits10<<"\n";
}