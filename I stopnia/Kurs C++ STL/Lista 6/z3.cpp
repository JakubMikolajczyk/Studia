//#include "head.h"

#include <iostream>
#include <vector>
#include <algorithm>
#include <map>
#include <vector>

int main(){

//    auto vec = std::vector<int> {1,2,4,3,1,5,4,2,3,5,32,1};
auto vec = std::vector<int> {1,2,3,4,4,2,3};
    auto map = std::map<int, int>();

    for (const auto &item : vec)
        map[item]++;


    auto vecPair = std::vector<std::pair<int, int>>();

    for (const auto &item : map)
        vecPair.push_back(item);


    std::sort(vecPair.begin(), vecPair.end(), [](auto a, auto b){
        return a.second > b.second;
    });

    auto it = vecPair.begin();
    it--;
    do {
        it++;
        std::cout<<"{Key: "<<it->first<<", Val: "<<it->second<<"}\n";
    } while (it != vecPair.end() && it->second == (it + 1)->second);
}