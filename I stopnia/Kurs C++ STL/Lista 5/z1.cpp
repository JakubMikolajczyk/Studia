#include <iostream>
#include <queue>
#include "head.h"

#include <stack>
#include <list>
#include <sstream>

enum operation {
    add = '+',
    sub = '-',
    mul = '*',
    divide = '/',
    pow = '^',
    left = '(',
    right = ')'
};

struct symbol {
    int val;
    bool isOperation;

    symbol(int val, bool isOperation = false) {
        this->val = val;
        this->isOperation = isOperation;
    }

    symbol(operation val, bool isOperation = true){
        this->val = val;
        this->isOperation = isOperation;
    }

    int eval() {
        if (isOperation)
            throw std::invalid_argument("It is operation need two values");

        return this->val;
    }

    int eval(int a, int b) {
        if (!isOperation)
            throw std::invalid_argument("Is is not operation");

        switch (val) {
            case add:
                return a + b;
            case sub:
                return a - b;
            case mul:
                return a * b;
            case divide:
                return a / b;
            case pow:
                return a ^ b;
        }

        throw std::invalid_argument("Invalid operation");
    }

    friend std::ostream &operator<<(std::ostream &os, const symbol &symbol) {
        if (symbol.isOperation)
            switch (symbol.val) {
                case add:
                    os<<"+ ";
                    break;
                case sub:
                    os<<"- ";
                    break;
                case mul:
                    os<<"* ";
                    break;
                case divide:
                    os<<"/ ";
                    break;
                case pow:
                    os<<"^ ";
                    break;
            }
        else
            os<< symbol.val<<" ";
        return os;
    }
};


int op_priority(operation op) {
    switch (op) {

        case add:
            return 1;
        case sub:
            return 1;
        case mul:
            return 2;
        case divide:
            return 2;
        case pow:
            return 3;
        case left:
            return 0;

    }
}


bool isNumber(const std::string &s) {
    int begin = 0;
    if (s[0] == '-' && s[1] != '\0')
        begin++;
    return !s.empty() && std::find_if(s.begin() + begin,
                                      s.end(), [](unsigned char c) { return !std::isdigit(c); }) == s.end();
}

operation toOp(std::string str) {

    switch (str[0]) {
        case '+':
            return operation::add;
        case '-':
            return operation::sub;
        case '*':
            return operation::mul;
        case '/':
            return operation::divide;
        case '^':
            return operation::pow;
        case '(':
            return operation::left;
        case ')':
            return operation::right;
    }

    std::cout<<str[0];
    throw std::invalid_argument("wrong operation");
}

std::list<symbol> onp(std::string str) {
    auto que = std::queue<std::string>();
    int pos = 0;

    while ((pos = str.find(' ')) != std::string::npos) {
        std::string token = str.substr(0, pos);
        que.push(token);
        str.erase(0, pos + 1);
    }
    que.push(str);

    auto stack = std::stack<operation>();
    auto list = std::list<symbol>();

    while (!que.empty()) {
        auto token = que.front();
        que.pop();

        if (isNumber(token))
            list.push_back(symbol(std::stoi(token)));
        else {

            auto op = toOp(token);
            switch (op) {
                case left:
                    stack.push(op);
                    break;

                case right:
                    while (stack.top() != left) {
                        list.push_back(symbol(stack.top()));
                        stack.pop();
                    }
                    stack.pop();
                    break;

                default:
                    while (!stack.empty() && op_priority(stack.top()) >= op_priority(op)) {
                        list.push_back(symbol(stack.top()));
                        stack.pop();
                    }
                    stack.push(op);
            }

        }

    };
    while (!stack.empty()){
        list.push_back(symbol(stack.top()));
        stack.pop();
    }

    return list;
}


void test(std::string str){

    try {
        auto t = onp(str);
        for (const auto &item : t)
            std::cout<<item;
        std::cout<<"\n";
    }
    catch(std::invalid_argument e){
        std::cout<<e.what();
    }
}


auto split_onp(std::string str){
    auto buf = std::stringbuf();

    for (auto it = str.begin(); it != str.end(); it++){;

        auto item = *it;
        if(std::isdigit(item))
            buf.sputc(item);
        else{
            if(item == '-' && isdigit(*(it + 1))){
                buf.sputc(item);
            } else
            {
                buf.sputc(' ');
                buf.sputc(item);
                buf.sputc(' ');
            }
        }
    }

    std::cout<<buf.str()<<"\n";
    return onp(buf.str());
}



void z1() {

    test("1 + 2 + 3");
    test("1 + 2 * 3");
    test("( 1 + 2 ) * 3");
    test("( ( 1 + 2 + 3 ) )");
    test("1 + 3 + 10 ^ ( 1 + 2 + 3 )");
    test("1 + 2 + 10 ^ 1 + 2 + 3");
    test("-1 + 23 - -2");

    auto t = split_onp("1--2--3+4+5+6");
    for (const auto &item : t)
        std::cout<<item;
    std::cout<<"\n";
}