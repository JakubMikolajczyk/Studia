#include "head.h"
#include <vector>

using it = std::vector<int>::iterator;

it left(it begin, it end, int val){
    if (std::distance(begin,end) == 0)
        return begin;
    int mid = int(std::distance(begin,end))/2;
    auto cmp = *(begin + mid) <=> val;
    if (cmp < 0)
        return left(begin + mid + 1, end, val);

    return left(begin, begin + mid, val);
}

it right(it begin, it end, int val){
    if (std::distance(begin,end) == 0)
        return end;
    int mid = int(std::distance(begin, end) + 1)/2;
    auto cmp = *(begin + mid) <=> val;
    if (cmp > 0)
        return right(begin, begin + mid - 1, val);
    return right(begin + mid, end, val);
}

int leftv2(int begin, int end, std::vector<int> vec, int val){

    if (begin == end)
        return begin;
    int mid = (begin + end)/2;
    auto cmp = vec[mid] <=> val;
    if (cmp < 0)
        return leftv2(mid + 1, end, vec, val);

    return leftv2(begin, mid,vec, val);
}

int rightv2(int begin, int end, std::vector<int> vec, int val){
    if (begin == end)
        return end;
    int mid = (begin + end + 1)/2;
    auto cmp = vec[mid] <=> val;
    if (cmp > 0)
        return rightv2(begin, mid - 1,vec,  val);
    return rightv2(mid, end,vec,  val);
}


std::pair<it , it> binSearchRange(std::vector<int> vec, int val){



    auto begin = left(vec.begin(), vec.end(),val);
    auto end = right(vec.begin(),vec.end(),val);

//    int a = leftv2(0, vec.size() - 1, vec, val);
//    int b = rightv2(0, vec.size() - 1, vec, val);
//    std::cout<< a<<" "<< b<<"\n";
//    auto begin = vec.begin() + a;
//    auto end = vec.begin() + b;

//    std::cout<< *(begin - 1)<< " ";
//    std::cout<< *(end + 1)<<"\n";

    return std::make_pair(begin,end);
}

void z9(){
    std::vector<int> vec = {1, 2, 2, 3, 4, 4, 4, 4, 5, 5};
    auto [begin, end] = binSearchRange(vec, 4);
    if(vec.begin() != begin)
        std::cout<<*(begin - 1)<<" ";
    else
        std::cout<<*(begin)<<" ";

    if (vec.end() != end)
        std::cout<<*(end + 1);
    else
        std::cout<<*(end);
}