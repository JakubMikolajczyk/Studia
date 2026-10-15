#include <iostream>

char tab[2000000][3];
bool attack[2000000][3];
int n;

bool isBlack(int i, int j) {
    if (i % 2 == 0) {
        return j % 2 == 0;
    } else {
        return j % 2 == 1;
    }
}

bool inBound(int i, int j) {
    return 0 <= i and i < n and 0 <= j and j < 3;
}

void setAttack(int i, int j) {
    if (inBound(i, j)) {
        attack[i][j] = true;
    }
}

void setAllAttack(int i, int j) {

    setAttack(i + 2, j - 1);
    setAttack(i + 2, j + 1);
    setAttack(i - 2, j - 1);
    setAttack(i - 2, j + 1);
    setAttack(i - 1, j + 2);
    setAttack(i + 1, j + 2);
    setAttack(i - 1, j - 2);
    setAttack(i + 1, j - 2);
}

int main() {
    std::cin >> n;
    int black = 0;
    int count = 0;
    for (int i = 0; i < n; i++)
        for (int j = 0; j < 3; j++) {
            std::cin >> tab[i][j];
            if (tab[i][j] == '.')
                black += isBlack(i, j);
        }

    for (int i = 0; i < n; i++)
        for (int j = 0; j < 3; j++)
            if (black > n * 3 / 2) {
                if (isBlack(i, j) and tab[i][j] == '.') {
                    tab[i][j] = 'S';
                    count += 1;
                    setAllAttack(i, j);
                }
            } else if (not isBlack(i, j) and tab[i][j] == '.') {
                tab[i][j] = 'S';
                count += 1;
                setAllAttack(i, j);
            }

    for (int i = 0; i < n; i++)
        for (int j = 0; j < 3; j++)
            if (not attack[i][j] and tab[i][j] == '.') {
                tab[i][j] = 'S';
                count += 1;
                setAllAttack(i, j);
            }

    std::cout << count << "\n";
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < 3; j++)
            std::cout << tab[i][j];
        std::cout << "\n";
    }

    return 0;
}
