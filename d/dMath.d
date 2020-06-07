module dmath;
import std.math: cos, exp, exp2, fabs, fmax, fmin, log, log10, 
                 log2, pow, round, sin, sqrt, PI;

/*
  ldc2 --d-version=verbose dMath.d -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./dMath
*/

/* Import benchmark functions */
mixin(import("bench.d"));

void main()
{
  runMathBench!(float)("D");
  runMathBench!(double)("D");
  runMathBench!(real)("D");
}

