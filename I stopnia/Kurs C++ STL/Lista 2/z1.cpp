#include <iostream>

const int times = 2;
const int n = 10;
const int m = 10;
class Counter{
    uint64_t count = 1;


    public:
    void addToCount(int val){
        this->count += val;
    }
    virtual ~Counter(){
        std::cerr<<count<<" ";
    }

    uint64_t getCount() const {
        return count;
    };
};

std::unique_ptr<Counter[]> rec(int i, std::unique_ptr<Counter[]> ptr){

//    srand(time(NULL));
    for(int a = 0; a < times; a++){
       int index = int(random() % n);
        ptr[index].addToCount(i);
    }
    if (i < m)
        return rec(++i, std::move(ptr));
    return ptr;
}

int main(){

    auto tab = std::unique_ptr<Counter[]>(new Counter[n]);

    tab = rec(0, std::move(tab));

    for(int i =0; i < n; i++)
        std::cout<<tab[i].getCount()<<" ";

    std::cout<<"\n";
}