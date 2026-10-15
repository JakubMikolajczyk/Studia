#include "head.h"

#include <iostream>
#include <complex>

const double euler = 0.5772156649;

std::complex<double> gamma(std::complex<double> z, int iter) {
    std::complex<double> result = 1.0 / z;

    for (int n = 1; n < iter; n++)
        result *= (std::pow(1.0 + 1.0 / static_cast<double>(n), z)) / (1.0 + z / static_cast<double>(n));

    return result;
}

std::complex<double> inverse_gamma(std::complex<double> z, int iter) {
    std::complex<double> result = z * std::exp(euler * z);
    for (int n = 1; n < iter; n++)
        result *= (1.0 + z / static_cast<double>(n)) * std::exp(-z / static_cast<double>(n));
    return result;
}

void z2() {

    std::cout << gamma(std::complex<double>(12, 4), 1000000) << "\n";
    std::cout << inverse_gamma(std::complex<double>(12, 4), 1000000) << "\n";

    std::cout << "TEST: "<< gamma(std::complex<double>(12, 4), 1000000) * inverse_gamma(std::complex<double>(12, 4), 1000000);
}