#include <iostream>
#include <cmath>
#include <vector>
#include <algorithm>

struct Point {
    long long int x;
    long long int y;

    Point(long long int x1, long long int y1) : x(x1), y(y1) {}

    Point() : x(0), y(0) {}


};

bool compareX(Point p1, Point p2) {
    return p1.x < p2.x;
}

bool compareY(Point p1, Point p2) {
    return p1.y < p2.y;
}

float distance(Point p1, Point p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

std::pair<float, std::pair<Point, Point> >
min(std::pair<float, std::pair<Point, Point> > a, std::pair<float, std::pair<Point, Point> > b) {
    if (a.first < b.first)
        return a;
    else
        return b;
}

std::pair<float, std::pair<Point, Point> >
between(std::vector<Point> tab, std::pair<float, std::pair<Point, Point> > pair) {

    std::sort(tab.begin(), tab.end(), compareY);
    float min = pair.first;
    std::pair<Point, Point> minP = pair.second;

    for (long unsigned int i = 0; i < tab.size(); i++)
        for (long unsigned int j = i + 1; j < tab.size() and float(tab[j].y - tab[i].y) < min; j++) {
            float dis = distance(tab[i], tab[j]);
            if (dis < min) {
                min = dis;
                minP = std::make_pair(tab[i], tab[j]);
            }
        }
    return std::make_pair(min, minP);
}

std::pair<float, std::pair<Point, Point> > closest(Point p[], int n) {

    if (n <= 3) {    // bruteForce
        float min = 100000001.0;
        std::pair<Point, Point> minP = std::make_pair(Point(), Point());
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++) {
                float d = distance(p[i], p[j]);
                if (d < min) {
                    min = d;
                    minP = std::make_pair(p[i], p[j]);
                }

            }
        return std::make_pair(min, minP);
    }

    int mid = n / 2;
    Point midPoint = p[mid];
    std::pair<float, std::pair<Point, Point> > dl = closest(p, mid);
    std::pair<float, std::pair<Point, Point> > dr = closest(p + mid, n - mid);

    std::pair<float, std::pair<Point, Point> > minP = min(dl, dr);

    std::vector<Point> tab;

    for (int i = 0; i < n; i++)
        if ( float(abs(p[i].x - midPoint.x)) < minP.first)
            tab.push_back(p[i]);

    return min(minP, between(tab, minP));
}

Point points[10000000];

int main() {

    int n;
    std::cin >> n;
    for (int i = 0; i < n; i++) {
        long long int x2, y2;
        std::cin >> x2 >> y2;
        points[i] = Point(x2, y2);
    }

    std::sort(points, points + n, compareX);
    std::pair<float, std::pair<Point, Point> > ans = closest(points, n);

    std::cout << ans.second.first.x << " " << ans.second.first.y << " \n";
    std::cout << ans.second.second.x << " " << ans.second.second.y;

    return 0;
}
