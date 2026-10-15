#include <iostream>
#include <map>
#include <vector>

struct point{

    int x;
    int y;

    point() = default;
    point(int x, int y) : x(x), y(y) {}

    bool operator<(const point &rhs) const {
        if (x < rhs.x)
            return true;
        if (rhs.x < x)
            return false;
        return y < rhs.y;
    }

    bool operator>(const point &rhs) const {
        return rhs < *this;
    }

    bool operator<=(const point &rhs) const {
        return !(rhs < *this);
    }

    bool operator>=(const point &rhs) const {
        return !(*this < rhs);
    }

    friend std::ostream &operator<<(std::ostream &os, const point &point) {
        os << "x: " << point.x << " y: " << point.y;
        return os;
    }

};

std::map<point, std::vector<point>> edges;
std::map<point, int> nodeVal;

const int mod = 999979;

int main() {


    int m, n, t;
    std::cin>>m>>n>>t;

    for(int i = 0; i < t; i++){
        int a1, a2, b1, b2;
        std::cin>>a1>>a2>>b1>>b2;
        edges[point(a1,a2)].push_back(point(b1, b2));
    }

    nodeVal[point(0, 0)] = 1;

    for (auto p: nodeVal){
        for(auto edge: edges[p.first]){
            nodeVal[edge] += p.second % mod;
        }
    }

    std::cout<<nodeVal[point(m,n)] % mod;

    return 0;
}
