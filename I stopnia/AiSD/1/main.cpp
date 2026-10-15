#include <iostream>
#include <queue>

bool visisted[2001][2001];
char tab[2001][2001];
int n,m;

bool notInBound(int i, int j){
    return  !(0 <= i and i < m and
            0 <= j and j < n);
}

/*
 * UP - B E F
 * DOWN - C D F
 * LEFT - D E F
 * RIGHT - B C F
 */

bool up(int i, int j){
    if (notInBound(i,j))
        return false;

    char city = tab[i][j];
    if (city == 'C' or city == 'D' or city == 'F')
        return true;
    return false;
}

bool down(int i, int j){
    if (notInBound(i,j))
        return false;

    char city = tab[i][j];
    if (city == 'B' or city == 'E' or city == 'F')
        return true;
    return false;
}

bool left(int i, int j){
    if (notInBound(i,j))
        return false;

    char city = tab[i][j];
    if (city == 'B' or city == 'C' or city == 'F')
        return true;
    return false;
}

bool right(int i, int j){
    if (notInBound(i,j))
        return false;

    char city = tab[i][j];
    if (city == 'D' or city == 'E' or city == 'F')
        return true;
    return false;
}

void DFS(int i, int j){

    visisted[i][j] = true;
    char city = tab[i][j];

    if(up(i, j) and down(i, j - 1 ) and not visisted[i][j - 1])
        DFS(i, j - 1);

    if(down(i, j) and up(i, j + 1) and not visisted[i][j + 1])
        DFS(i, j + 1);

    if(left(i, j) and right(i - 1, j) and not visisted[i - 1][j])
        DFS(i - 1, j);

    if(right(i, j) and left(i + 1, j) and not visisted[i + 1][j])
        DFS(i + 1, j);

}

void DFSv2(int a, int b){

    std::queue<std::pair<int, int>> que;
    que.push(std::make_pair(a,b));
    while (!que.empty()) {
        int i = que.front().first;
        int j = que.front().second;
        que.pop();
        visisted[i][j] = true;
        char city = tab[i][j];

        if (up(i, j) and down(i, j - 1) and not visisted[i][j - 1])
            que.push(std::make_pair(i, j - 1));

        if (down(i, j) and up(i, j + 1) and not visisted[i][j + 1])
            que.push(std::make_pair(i, j + 1));

        if (left(i, j) and right(i - 1, j) and not visisted[i - 1][j])
            que.push(std::make_pair(i - 1, j));

        if (right(i, j) and left(i + 1, j) and not visisted[i + 1][j])
            que.push(std::make_pair(i + 1, j));
    }

}

int main() {
    std::cin>>n>>m;
    int cities = 0;

    for (int j = 0; j < n; j++)
        for (int i = 0; i < m; i++)
            std::cin>>tab[i][j];

    for (int j = 0; j < n; j++)
        for (int i = 0; i < m; i++){
            if (tab[i][j] == 'A')
                visisted[i][j] = true;
            else
                if (!visisted[i][j]){
                    cities++;
                    DFSv2(i, j);
                }
        }

    std::cout<<cities;
    return 0;
}
