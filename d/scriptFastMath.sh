#!/usr/bin/bash

# Run the D math benchmark
ldc2 --d-version=verbose --d-version=fastmath dMath.d --release -O --boundscheck=off --ffast-math -mcpu=native -J="." && /usr/bin/time -v ./dMath
# Run the C math benchmark
ldc2 --d-version=verbose --d-version=fastmath cMath.d --release -O --boundscheck=off --ffast-math -mcpu=native -J="." && /usr/bin/time -v ./cMath
# Run the LLVM Math benchmark
ldc2 --d-version=verbose --d-version=fastmath llvmMath.d --release -O --boundscheck=off --ffast-math -mcpu=native -J="." && /usr/bin/time -v ./llvmMath

