#include <type_traits>
#include <iostream>

template<typename A, typename B>
void move_imp(A &from, B& to, std::true_type) {
    if(std::is_convertible<std::remove_pointer<A>, B>::value)
        to = std::move(*from);
    else
        throw std::invalid_argument("Cannot convert");
}

template<typename A, typename B>
void move_imp(A &&from, B& to, std::false_type) {
    if(std::is_convertible<A,B>::value)
        to = std::move(from);
    else
        throw std::invalid_argument("Cannot convert");
}

template<typename A, typename B>
void move(A from, B& to) {
    move_imp(from, to, std::is_pointer<A>());
}

class A{};
class B:A{};

class C{};

int main() {

    int *_intptr = new int(21);
    float _float;
    int _intdest;
    float a = 21.21f;
    std::string *_strptr = new std::string("Test");
    std::string _strdest;
    std::string _str2;


    move(_intptr,_float);
    std::cout<<"\n*int -> float\n*int: "<<*_intptr<<" float: "<<_float;

    move(21.21, _intdest);
    std::cout<<"\ndouble val -> int\ndouble: "<<1234.34<<" int: "<<_intdest;

    move(_strptr, _strdest);
    std::cout<<"\n*str -> str\n*str: "<<*_strptr<<" str: "<<_strdest;




}