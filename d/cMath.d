module cmath;

import core.stdc.math:   cos = cosf,   cos,     cos = cosl,
                         exp = expf,   exp,     exp = expl,
                        exp2 = exp2f,  exp2,   exp2 = exp2l,
                        fabs = fabsf,  fabs,   fabs = fabsl,
                        fmax = fmaxf,  fmax,   fmax = fmaxl,
                        fmin = fminf,  fmin,   fmin = fminl,
                         log = logf,   log,     log = logl,
                       log10 = log10f, log10, log10 = log10l,
                        log2 = log2f,  log2,   log2 = log2l,
                         pow = powf,   pow,     pow = powl,
                       round = roundf, round, round = roundl,
                         sin = sinf,   sin,     sin = sinl,
                        sqrt = sqrtf,  sqrt,   sqrt = sqrtl;
import std.math: PI;

/*
  ldc2 --d-version=verbose cMath.d -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./cMath
*/


/* Import benchmark functions */
mixin(import("bench.d"));

void main()
{
  runMathBench!(float)("C");
  runMathBench!(double)("C");
  runMathBench!(real)("C");
}
