module llvmmath;
import std.math: PI;

pragma(LDC_intrinsic, "llvm.sqrt.f32")
nothrow @nogc pure @safe float sqrt(float);
pragma(LDC_intrinsic, "llvm.sqrt.f64")
nothrow @nogc pure @safe double sqrt(double);
pragma(LDC_intrinsic, "llvm.sqrt.f80")
nothrow @nogc pure @safe real sqrt(real);

pragma(LDC_intrinsic, "llvm.sin.f32")
nothrow @nogc pure @safe float sin(float);
pragma(LDC_intrinsic, "llvm.sin.f64")
nothrow @nogc pure @safe double sin(double);
pragma(LDC_intrinsic, "llvm.sin.f80")
nothrow @nogc pure @safe real sin(real);

pragma(LDC_intrinsic, "llvm.cos.f32")
nothrow @nogc pure @safe float cos(float);
pragma(LDC_intrinsic, "llvm.cos.f64")
nothrow @nogc pure @safe double cos(double);
pragma(LDC_intrinsic, "llvm.cos.f80")
nothrow @nogc pure @safe real cos(real);

pragma(LDC_intrinsic, "llvm.pow.f32")
nothrow @nogc pure @safe float pow(float, float);
pragma(LDC_intrinsic, "llvm.pow.f64")
nothrow @nogc pure @safe double pow(double, double);
pragma(LDC_intrinsic, "llvm.pow.f80")
nothrow @nogc pure @safe real pow(real, real);

pragma(LDC_intrinsic, "llvm.exp.f32")
nothrow @nogc pure @safe float exp(float);
pragma(LDC_intrinsic, "llvm.exp.f64")
nothrow @nogc pure @safe double exp(double);
pragma(LDC_intrinsic, "llvm.exp.f80")
nothrow @nogc pure @safe real exp(real);

pragma(LDC_intrinsic, "llvm.log.f32")
nothrow @nogc pure @safe float log(float);
pragma(LDC_intrinsic, "llvm.log.f64")
nothrow @nogc pure @safe double log(double);
pragma(LDC_intrinsic, "llvm.log.f80")
nothrow @nogc pure @safe real log(real);

pragma(LDC_intrinsic, "llvm.fabs.f32")
nothrow @nogc pure @safe float fabs(float);
pragma(LDC_intrinsic, "llvm.fabs.f64")
nothrow @nogc pure @safe double fabs(double);
pragma(LDC_intrinsic, "llvm.fabs.f80")
nothrow @nogc pure @safe real fabs(real);

pragma(LDC_intrinsic, "llvm.exp2.f32")
nothrow @nogc pure @safe float exp2(float);
pragma(LDC_intrinsic, "llvm.exp2.f64")
nothrow @nogc pure @safe double exp2(double);
pragma(LDC_intrinsic, "llvm.exp2.f80")
nothrow @nogc pure @safe real exp2(real);

pragma(LDC_intrinsic, "llvm.log10.f32")
nothrow @nogc pure @safe float log10(float);
pragma(LDC_intrinsic, "llvm.log10.f64")
nothrow @nogc pure @safe double log10(double);
pragma(LDC_intrinsic, "llvm.log10.f80")
nothrow @nogc pure @safe real log10(real);

pragma(LDC_intrinsic, "llvm.log2.f32")
nothrow @nogc pure @safe float log2(float);
pragma(LDC_intrinsic, "llvm.log2.f64")
nothrow @nogc pure @safe double log2(double);
pragma(LDC_intrinsic, "llvm.log2.f80")
nothrow @nogc pure @safe real log2(real);

pragma(LDC_intrinsic, "llvm.round.f32")
nothrow @nogc pure @safe float round(float);
pragma(LDC_intrinsic, "llvm.round.f64")
nothrow @nogc pure @safe double round(double);
pragma(LDC_intrinsic, "llvm.round.f80")
nothrow @nogc pure @safe real round(real);

pragma(LDC_intrinsic, "llvm.minnum.f32")
nothrow @nogc pure @safe float fmin(float, float);
pragma(LDC_intrinsic, "llvm.minnum.f64")
nothrow @nogc pure @safe double fmin(double, double);
pragma(LDC_intrinsic, "llvm.minnum.f80")
nothrow @nogc pure @safe real fmin(real, real);

pragma(LDC_intrinsic, "llvm.maxnum.f32")
nothrow @nogc pure @safe float fmax(float, float);
pragma(LDC_intrinsic, "llvm.maxnum.f64")
nothrow @nogc pure @safe double fmax(double, double);
pragma(LDC_intrinsic, "llvm.maxnum.f80")
nothrow @nogc pure @safe real fmax(real, real);


/*
  ldc2 --d-version=verbose llvmMath.d -O --boundscheck=off -mcpu=native -J="." && /usr/bin/time -v ./llvmMath
*/


/* Import benchmark functions */
mixin(import("bench.d"));

void main()
{
  runMathBench!(float)("LLVM");
  runMathBench!(double)("LLVM");
  runMathBench!(real)("LLVM");
}

