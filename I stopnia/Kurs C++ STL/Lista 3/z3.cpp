#include <ratio>
#include <iostream>

//#define ratio(n) std::ratio<1, n>
#define ratioPrint(ratio) std::cout<<ratio::num <<"/"<<ratio::den<<"\n"

template <intmax_t n> struct harmonic
{
        using a = typename harmonic<n - 1>::value;
        using value = std::ratio_add<std::ratio<1,n>, a>;
};

template <> struct harmonic<1>
{
     using value = std::ratio<1,1>;
};


int main(){

    using test = harmonic<46>::value;
    ratioPrint(test);
//    std::cout<<test;

}