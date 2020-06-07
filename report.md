# Benchmarking mathematical functions available in D

## Introduction

Math functions available in standard libraries are often taken for granted, we use them as a matter of course with little thought, but their performance **is** essential particularly for process that execute large scale calculations. With that in mind, this article carries out benchmarks for a selection of frequently used mathematics functions available in the D programming language.

D makes three basic mathematics libraries available, [`std.math`](https://dlang.org/library/std/math.html) from its standard library, [`core.stdc.math`](https://dlang.org/library/core/stdc/math.html) which is the C mathematics library made available in the D compiler, and then functions from LLVM using the LDC compiler using [`LDC_intrinsic`s](https://wiki.dlang.org/LDC-specific_language_changes#LDC_intrinsic).

The mathematical functions `cos`, `exp`, `exp2`, `fabs`, `fmax`, `fmin`, `log`, `log10`, `log2`, `pow`, `round`, `sin`, `sqrt` are benchmarked for `float`, `double`, and `real` that is 32 bit, 64 bit, and 80 bit floating point types respectively. The functions were executed on values in arrays generated using a random number generator with sizes (100k, 500k, 1M, 5M, 10M, 100M) (k = thousand, M = Million). The `pow` (exponential) functions also were tested using exponents (-1.0, -0.75, -0.5, -0.25, 0.0, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0,  2.25,  2.5, 2.75, 3.0). The code for this article is located in a [GitHub repository](https://github.com/dataPulverizer/DmathBench). The outputs for the `pow` function is presented separately from the other functions since multiple exponents are examined.

It is worth mentioning that performance is an important factor to think about then considering which mathematics library to use, but it is just *one* of multiple factors you should consider so bear that in mind as you read this article.

## Outputs

### Performance for each floating point type

Below are log-log charts showing outputs for each library and function for the `float` type. For `exp`, `exp2`, `fmax`, `fmin`, and `log` functions the `std.math` library functions are markedly slower than the the other libraries.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotFloat.jpg" width="800">

The case for using `double` type replicates the above profile.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotDouble.jpg" width="800">

However for floating type `real` D matches the performance of C and LLVM and out performs both `exp` and `exp2` functions.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotReal.jpg" width="800">

### The cost of more bits

Here the above results are presented from the floating point type view for each language. It shows the cost of the various floating point types for each library.

D has very little difference in performance between floating point types for all but `sin` and `cos` functions, `fabs`, `round`, and `sqrt` show some but much reduced sensitivity to using higher accuracy floating types.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotD.jpg" width="800">

C library functions show much higher sensitivity to floating point types in comparison to D.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotC.jpg" width="800">

LLVM library replicate sensitivity to floating point types that C has.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotLLVM.jpg" width="800">

### Exponential function benchmarks

In this section the benchmarks for the exponential functions are presented, and only the y-axis have a log scale. The performance for `pow` function replicates the performance outputs for 32 and 64 bit floats, however for 80 bit floats, D’s `std.math` functions outperforms C and LLVM libraries. The chart panels for 32 and 64 bit floats is given below. It is clear from the performance profile that there is a different implementation approach between `std.math` and the other libraries, with `std.math`’s `pow` function being almost an order of magnitude slower.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotPowFloat.jpg" width="800">

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotPowDouble.jpg" width="800">

However, the performance pattern inverts for 80 bit floats. It looks like all the implementations make use of special cases of whole number exponents as multiplications. As the whole number exponents increase the execution times increase. For the other exponents D’s implementation is clearly much more efficient.

<img src="https://github.com/dataPulverizer/DMathBench/blob/master/charts/plotPowReal.jpg" width="800">

## Summary

Mathematics libraries are at the heart of scientific computing, many important processes rely on their performance and accuracy. This article presents considerations that programmers should bear in mind when using any mathematics library. We should always consider how efficient the implementation of the mathematics library and weigh that against the floating point types used, and not take anything for granted. We shouldn’t assume that certain approaches will lead to better performance but always benchmark to confirm or refute our hypothesis.
