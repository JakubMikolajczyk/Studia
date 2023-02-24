#include <iostream>
#include <regex>


void z1(){
    std::string input;
    std::cin>>input;

    std::regex time("^(0[0-9]|1[0-9]|2[0-3])"
                    ":([0-5][0-9])"
                    "(:[0-5][0-9])?$");
    std::cout<<input<<" is "<<std::regex_match(input, time);
}