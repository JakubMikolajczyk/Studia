#include <iostream>
#include <math.h>
#include <vector>
#include <algorithm>

struct Point {
    int x;
    int y;

    Point(int x, int y) : x(x), y(y) {}
    Point() : x(0), y(0) {}


};

bool compareX(Point p1, Point p2) {
    return p1.x < p2.x;
}

bool compareY(Point p1, Point p2) {
    return p1.y < p2.y;
}

long double distance(Point p1, Point p2) {
    return sqrtl(powl((long double)(p1.x - p2.x), 2) + powl((long double)(p1.y - p2.y), 2));
}

std::pair<long double, std::pair<Point, Point>>
min(std::pair<long double, std::pair<Point, Point>> a, std::pair<long double, std::pair<Point, Point>> b) {
    if (a.first < b.first)
        return a;
    else
        return b;
}

std::pair<long double, std::pair<Point, Point>> between(std::vector<Point> tab, std::pair<long double, std::pair<Point, Point>> pair) {

    std::sort(tab.begin(), tab.end(), compareY);
    long double min = pair.first;
    std::pair<Point, Point> minP = pair.second;

    for (int i = 0; i < tab.size(); i++)
        for (int j = i + 1; j < tab.size() and (tab[j].y - tab[i].y) < min; j++) {
            long double dis = distance(tab[i], tab[j]);
            if (dis < min) {
                min = dis;
                minP = std::make_pair(tab[i], tab[j]);
            }
        }
    return std::make_pair(min, minP);
}

std::pair<long double, std::pair<Point, Point>> closest(Point p[], int n) {

    if (n <= 3) {    // bruteForce
        long double min = 100000001;
        std::pair<Point, Point> minP = std::make_pair(Point(0, 0), Point(0, 0));
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++) {
                long double d = distance(p[i], p[j]);
                if (d < min) {
                    min = d;
                    minP = std::make_pair(p[i], p[j]);
                }

            }
        return std::make_pair(min, minP);
    }

    int mid = n / 2;
    Point midPoint = p[mid];
    std::pair<long double, std::pair<Point, Point>> dl = closest(p, mid);
    std::pair<long double, std::pair<Point, Point>> dr = closest(p + mid, n - mid);

    std::pair<long double, std::pair<Point, Point>> minP = min(dl, dr);

    std::vector<Point> tab;

    for (int i = 0; i < n; i++)
        if (abs(p[i].x - midPoint.x) < minP.first)
            tab.push_back(p[i]);

    return min(minP, between(tab, minP));
}

Point points[10000000];

int main() {

    int n;
    std::cin >> n;
    for (int i = 0; i < n; i++) {
        int x, y;
        std::cin >> x >> y;
        points[i] = Point(x, y);
    }

    std::sort(points, points + n, compareX);
    std::pair<long double, std::pair<Point, Point>> ans = closest(points, n);

    std::cout << ans.second.first.x << " " << ans.second.first.y <<" \n";
    std::cout << ans.second.second.x << " " << ans.second.second.y;

    return 0;
}