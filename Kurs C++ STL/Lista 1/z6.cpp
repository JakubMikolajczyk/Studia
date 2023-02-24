#include "head.h"
#include <cmath>

void z6(){

    int a,b,c;
    std::cin>>a>>b>>c;


    if(int delta = b*b - 4 * a * c; delta >= 0){
        if(delta > 0){
            std::cout<<"x1: "<< (-b - sqrt(delta))/2*a<<"  x2: "<< (-b + sqrt(delta))/2*a;
        } else{
            std::cout <<"x0: "<< -b/2*a;
        }
    } else{
        std::cout<<"Brak rozwiazania";
    }
}
