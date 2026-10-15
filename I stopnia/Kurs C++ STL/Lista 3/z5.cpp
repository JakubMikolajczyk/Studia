#include <iostream>

class Matrix{

    double *tab;
    int maxI;
    int maxJ;
    std::chrono::time_point<std::chrono::high_resolution_clock> start;

    static double RandomDouble(double a, double  b){
        double random = ((double) rand()/ RAND_MAX);
        double diff = b - a;
        double r = random * diff;
        return r + a;
    }
public:

    Matrix(int n, int m){
        start = std::chrono::high_resolution_clock::now();
        tab = new double [n * m];
        maxI = n;
        maxJ = m;
        for(int i = 0; i < maxI * maxJ; i++)
                tab[i] = RandomDouble(0.5, 2.0);
    }

    void pow(){
        for(int i = 0; i < maxI * maxJ; i++)
                tab[i] *= tab[i];
    }

    void print(){
        for(int i = 0; i < maxI * maxJ; i++) {
            if(i%maxJ == 0)
                std::cout<<"\n";

            std::cout<<tab[i]<<" ";
        }
        std::cout<<"\n\n";
    }

    double& operator()(int i, int j) {
        return tab[i + j * maxI];
    }

    ~Matrix(){
        auto end = std::chrono::high_resolution_clock::now();
        auto sec = std::chrono::duration_cast<std::chrono::milliseconds>((end - start));
        std::cout<<"On destruction time: "<<sec.count()<<"\n";
    }
};

int main(){
    {
        int n = 100000;
        auto _100 = Matrix(100, 100);
        auto start = std::chrono::high_resolution_clock::now();
        for(int i = 0; i < n; i++)
            _100.pow();
        auto end = std::chrono::high_resolution_clock::now();
        auto sec = std::chrono::duration_cast<std::chrono::milliseconds>((end - start));
        std::cout<<sec.count()/n<<"\n";
    }

    {
        auto _1000 = Matrix(1000, 1000);
        auto start = std::chrono::high_resolution_clock::now();
        _1000.pow();
        auto end = std::chrono::high_resolution_clock::now();
        auto sec = std::chrono::duration_cast<std::chrono::milliseconds>((end - start));
        std::cout<<sec.count()<<"\n";
    }

    {
        auto _10000 = Matrix(10000, 10000);
        auto start = std::chrono::high_resolution_clock::now();
        _10000.pow();
        auto end = std::chrono::high_resolution_clock::now();
        auto sec = std::chrono::duration_cast<std::chrono::milliseconds>((end - start));
        std::cout<<sec.count()<<"\n";
    }

    {
        auto _100000 = Matrix(100000, 100000);
        auto start = std::chrono::high_resolution_clock::now();
        _100000.pow();
        auto end = std::chrono::high_resolution_clock::now();
        auto sec = std::chrono::duration_cast<std::chrono::milliseconds>((end - start));
        std::cout<<sec.count()<<"\n";
    }

}