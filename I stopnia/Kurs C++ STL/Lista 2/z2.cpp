#include <fstream>
#include <iostream>

class File{

    std::ofstream *stream;

public:
    File(){
        std::cerr<<"Opening file\n";
        this->stream = new std::ofstream();
        this->stream->open("../plik.txt");
    }
    ~File(){
        std::cerr<<"Closing file\n";
        this->stream->close();
        delete this->stream;
    }
    void writeSmth(const std::string &str){
        std::cerr<<"Writing to file\n";
        *this->stream<<str<<"\n";
    }
};

int main(){


    std::shared_ptr<File> file(new File());
    std::shared_ptr<File>& p1(file);
    std::shared_ptr<File>& p2(file);
    std::shared_ptr<File>& p3(file);
    std::shared_ptr<File>& p4(file);
    std::shared_ptr<File>& p5(file);
    std::shared_ptr<File>& p6(file);
//
    p1->writeSmth("p1");
    p2->writeSmth("p2");
    p3->writeSmth("p3");
    p4->writeSmth("p4");
    p5->writeSmth("p5");
    p6->writeSmth("p6");

}