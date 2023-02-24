#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include <map>


int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cout<<"WRONG";
        return -1;
    }

    int freq[26] ={};
    int letters = 0;

    std::ifstream ifstream(argv[1]);
    std::string   content;
    getline(ifstream, content, (char)ifstream.eof());

//    std::cout<<content;

    for (const auto &letter : content){
        if (letter >= 'a' && letter <= 'z') {
            letters++;
            freq[(int) letter - 97]++;
        }
        else if (letter >= 'A' && letter <= 'Z') {
            letters++;
            freq[(int) letter - 65]++;
        }
    }

    for (int i = 0; i < 26; i++)
        std::cout << (char)(i + 97) << ": " << (float)freq[i]/letters * 100<<"\n";
}