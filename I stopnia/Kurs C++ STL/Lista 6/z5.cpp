//#include "head.h"
#include <iostream>
#include <algorithm>


void perm(std::string str){
    std::sort(str.begin(), str.end());

    std::cout<<str<<"\n";
    while (std::next_permutation(str.begin(), str.end())){
        std::cout<<str<<"\n";
    }
}

int main(){

    perm("baca");

}