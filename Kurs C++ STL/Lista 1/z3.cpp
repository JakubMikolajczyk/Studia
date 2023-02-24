#include "head.h"
#include <set>

template<typename  T>
using mySet = std::set<T>;

mySet<std::string> test {"test", "test2", "test3", "dasfa", "dgfd", "rewgf", "gds"};

void z3() {
    for (auto i: test)
        std::cout << i<<"\n";
}