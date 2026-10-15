#include <limits>
#include <iostream>

int main(){

    auto _float = std::numeric_limits<float>();
    auto _double = std::numeric_limits<double>();

    std::cout<<"Float:\n";
    std::cout<<_float.min()<<"\n";
    std::cout<<_float.max()<<"\n";
    std::cout<<_float.epsilon()<<"\n";

    std::cout<<"Double:\n";
    std::cout<<_double.min()<<"\n";
    std::cout<<_double.max()<<"\n";
    std::cout<<_double.epsilon()<<"\n";
}