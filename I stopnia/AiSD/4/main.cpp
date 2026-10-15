#include <iostream>
#include <map>
#include <vector>
#include <algorithm>

const int maxN = 5 * 100000;
std::map<int, std::vector<int>> tree1;
std::map<int, std::vector<int>> tree2;

std::string recuretion(std::map<int, std::vector<int>> tree, int vertex, int parent){

    std::vector<std::string> child;


    for (int v : tree[vertex]){
        if (v != parent)
            child.push_back(recuretion(tree, v, vertex));
    }

    std::sort(child.begin(), child.end());
    std::string ret = "(";

    for (const auto& s : child){
        ret.append(s);
    }
    ret.append(")");
    return ret;
}

std::string canonical(std::map<int, std::vector<int>> tree){
    return recuretion(tree, 1, 0);
}

void solution(){

    tree1.clear();
    tree2.clear();
    int n;
    std::cin>>n;
    for (int i = 1; i < n; i++){
        int a,b;
        std::cin>>a>>b;
        tree1[a].push_back(b);
        tree1[b].push_back(a);
    }

    for (int i = 1; i < n; i++){
        int a,b;
        std::cin>>a>>b;
        tree2[a].push_back(b);
        tree2[b].push_back(a);
    }

    if (canonical(tree1) == canonical(tree2))
        std::cout<<"TAK\n";
    else
        std::cout<<"NIE\n";
}

int main(){
    int t;
    std::cin>>t;
    for (int i = 0; i < t; i++){
        solution();
    }
}