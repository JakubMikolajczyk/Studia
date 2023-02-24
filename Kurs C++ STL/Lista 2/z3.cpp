#include <memory>
#include <vector>
#include <set>
#include <iostream>

const int tries = 2;

enum Sex : int {
    female=0,
    male=1
};

class Alpaca {

    std::string name;
    Sex sex;
    std::shared_ptr<Alpaca> mother;
    std::shared_ptr<Alpaca> father;
    std::vector<std::weak_ptr<Alpaca> > childs;

    std::string stringSex() {
        switch (this->sex) {
            case male:
                return "m";
                break;
            case female:
                return "f";
                break;
        }
    }

    std::string stringMother(){
        if (this->mother != nullptr)
            return this->mother->name;
        else
            return "N";
    }

    std::string stringFather(){
        if (this->father != nullptr)
            return this->father->name;
        else
            return "N";
    }
public:

    Alpaca(const std::string& name, Sex sex, const std::shared_ptr<Alpaca>& mother = nullptr,
           const std::shared_ptr<Alpaca>& father = nullptr) : name(name), sex(sex), mother(mother), father(father) {
        std::cout << "NEW  name: " << this->name << " sex: " << stringSex()<<" mother: "<< stringMother() << " father: "<<stringFather()<< "\n";

    }

    ~Alpaca() {
        std::cout << "DEAD name: " << this->name << " sex: " << stringSex()<<" mother: "<< stringMother() << " father: "<<stringFather()<< "\n";
    }

    Sex getSex() const {
        return sex;
    }

    int howManyChildren() {
        int count = 0;
        for (const auto &a: this->childs) {
            if (!a.expired())
                count++;
        }
        return count;

    }

    void addKid(const std::shared_ptr<Alpaca> &kid) {
        this->childs.push_back(kid);
    }

    bool operator==(const Alpaca &rhs) const {
        return name == rhs.name;
    }

    bool operator!=(const Alpaca &rhs) const {
        return !(rhs == *this);
    }

    bool operator<(const Alpaca &rhs) const {
        return name < rhs.name;
    }

    bool operator>(const Alpaca &rhs) const {
        return rhs < *this;
    }

    bool operator<=(const Alpaca &rhs) const {
        return !(rhs < *this);
    }

    bool operator>=(const Alpaca &rhs) const {
        return !(*this < rhs);
    }
};


class AlpacaFarm{
    std::set<std::shared_ptr<Alpaca> > set;
    int i = 0;

    std::shared_ptr<Alpaca> select_random(){
        if(this->set.empty())
            return nullptr;
        auto n = random() % this->set.size();
        auto it = std::begin(this->set);
        std::advance(it, n);
        return *it;
    }

    std::shared_ptr<Alpaca> getRandomSex(Sex sex) {
        for (int j = 0; j < tries; j++){
            auto r = select_random();
            if (r != nullptr && r->getSex() == sex)
                return r;
        }
        return nullptr;
    }

public:

    void buyAlpaca() {
        std::cout<<"Buying alpaca\n";
        int sex = Sex(random() % 1);
        this->set.insert(std::shared_ptr<Alpaca>(new Alpaca(std::to_string(i), male)));
        this->i++;
    }

    void makeKid() {
        std::cout<<"Making kid\n";
        auto m = getRandomSex(male);
        auto f = getRandomSex(female);
        int sex = Sex(random() % 1);
        auto kid = std::shared_ptr<Alpaca>(new Alpaca(std::to_string(i), female, f, m));
        this->set.insert(kid);
        if (m != nullptr)
            m->addKid(kid);
        if (f != nullptr)
            f->addKid(kid);

        this->i++;
    }

    void killAlpaca(){
        std::cout<<"Killing alpaca\n";
        this->set.erase(select_random());
    }

    void randomOperation(){
        switch (int op = random() % 3; op) {
            case 0:
                buyAlpaca();
                break;
            case 1:
                makeKid();
                break;
            case 2:
                killAlpaca();
                break;
        }
    }
};



void kidTest() {

    std::shared_ptr<Alpaca> m1(new Alpaca("Male1", male));
    std::shared_ptr<Alpaca> f1(new Alpaca("Female1", female));

    std::shared_ptr<Alpaca> kid(new Alpaca("Kid1", male, f1, m1));
    m1->addKid(kid);
    f1->addKid(kid);

    assert(f1->howManyChildren() == 1);
    assert(m1->howManyChildren() == 1);

    kid.reset();

    assert(f1->howManyChildren() == 0);
    assert(m1->howManyChildren() == 0);
}

int main() {

    kidTest();

    AlpacaFarm farm;
    int a = 10;
    while (a--)
        farm.randomOperation();




}