#include "head.h"

#include <iostream>
#include <complex>
#include <fstream>

const double euler = 0.5772156649;

std::complex<double> gamma1(std::complex<double> z, int iter) {
    std::complex<double> result = 1.0 / z;

    for (int n = 1; n < iter; n++)
        result *= (std::pow(1.0 + 1.0 / static_cast<double>(n), z)) / (1.0 + z / static_cast<double>(n));

    return result;
}

std::complex<double> inverse_gamma1(std::complex<double> z, int iter) {
    std::complex<double> result = z * std::exp(euler * z);
    for (int n = 1; n < iter; n++)
        result *= (1.0 + z / static_cast<double>(n)) * std::exp(-z / static_cast<double>(n));
    return result;
}

std::complex<double> zeta(std::complex<double> z, int iter) {
    std::complex<double> result = 0.0;

    if (z.real() > 1) {
        for (int n = 1; n < iter; n++)
            result += 1.0 / std::pow(static_cast<double>(n), z);

        return result;
    } else if (z.real() >= 0 && z.real() <= 1) {
        for (int n = 1; n < iter; n++)
            result += std::pow(-1.0, n + 1) * std::pow(n, -z);

        return result / (1.0 - std::pow(2.0, -z + 1.0));
    } else {
        for (int n = 1; n < iter; n++)
            result = std::pow(2.0, z) * std::pow(M_PI, z - 1.0)
                     * sin(M_PI * z / 2.0) * gamma1(1.0 - z, iter)
                     * zeta(1.0 - z, iter);

        return result;
    }
}

void csv(double min, double max, double step, int iter, std::string output) {

    std::ofstream out(output);

    for (; min < max; min += step) {
        auto result = zeta(std::complex<double>(0.5, min), iter);
        out << min << "; " << result.real() << "; " << result.imag() << "\n";
    }

}

void z3() {

    csv(-30, 30, 0.01, 10000, "result.csv");
}