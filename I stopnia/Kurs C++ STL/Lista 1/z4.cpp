#include "head.h"


enum class Name : uint16_t{
    Kuba,
    Karol,
    Wiktor,
    Kasia,
    Amelia
};

void say(const std::string& msg, Name name){
    switch (name) {
        case Name::Kuba:
            std::cout<<msg<< " Kuba\n";
            break;
        case Name::Karol:
            std::cout<<msg<< " Karol\n";
            break;
        case Name::Wiktor:
            std::cout<<msg<< " Wiktor\n";
            break;
        case Name::Kasia:
            std::cout<<msg<< " Kasia\n";
            break;
        case Name::Amelia:
            std::cout<<msg<< " Amelia\n";
            break;
    }
}

void z4(){

    say("Test", Name::Kuba);
    say("dfsgsdgsd ", Name::Amelia);

}