#!/usr/bin/bash

# Run the D math benchmark
ldc2 --d-version=verbose dMath.d --release -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./dMath
# Run the C math benchmark
ldc2 --d-version=verbose cMath.d --release -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./cMath
# Run the LLVM Math benchmark
ldc2 --d-version=verbose llvmMath.d --release -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./llvmMath

