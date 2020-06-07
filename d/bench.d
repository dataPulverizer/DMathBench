// Lookup table
template getRange(string fun, T = double)
{
  static if(fun == "Pow")
    enum T[2] getRange = [0.0, PI];
  else static if(fun == "Sqrt" || fun == "Log" || 
            fun == "Log10" || fun == "Log2")
    enum T[2] getRange = [0.0, 1000.0];
  else
    enum T[2] getRange = [-PI, PI];
}

template getClassTemplate(Type: Base!Args, alias Base, Args...)
{
  enum getClassTemplate = Base.stringof[0..($ - 3)];
}

enum funcsOne = ["cos", "exp", "exp2", "fabs", "log", "log10", 
                 "log2", "round", "sin", "sqrt"];
enum funcsOneNames = ["Cos", "Exp", "Exp2", "Fabs", "Log", "Log10", 
                 "Log2", "Round", "Sin", "Sqrt"];

enum funcsTwo = ["fmax", "fmin", "pow"];
enum funcsTwoNames = ["Fmax", "Fmin", "Pow"];

template FunReprOne(string fun, string funName)
{
  enum FunReprOne = 
  "class " ~ funName ~ "(A)
  {
    public:
    A opCall(A arg) const
    {
      return " ~ fun ~ "(arg);
    }
  }
  ";
}
static foreach(i, fun; funcsOne)
      mixin(FunReprOne!(fun, funcsOneNames[i]));


template FunReprTwo(string fun, string funName)
{
  enum FunReprTwo = 
  "class " ~ funName ~ "(A)
  {
    public:
    A opCall(A arg1, A arg2) const
    {
      return " ~ fun ~ "(arg1, arg2);
    }
  }
  ";
}
static foreach(i, fun; funcsTwo)
      mixin(FunReprTwo!(fun, funcsTwoNames[i]));


// For include
import std.conv: to;
import std.parallelism;
import std.range : iota;
import std.stdio: File, write, writeln;
import std.algorithm : sum;
import std.random: uniform;
import std.typecons: tuple, Tuple;
import std.datetime.stopwatch: AutoStart, StopWatch;

auto rand(T, T lower, T upper)(size_t n)
{
  auto arr = new T[n];
  //foreach(ref el; arr)
  foreach(i; taskPool.parallel(iota(n)))
    arr[i] = uniform!("()")(lower, upper);
  return arr;
}

/*
  For functions with a single input and a single output
*/
auto applyOne(T, alias F)(F!T fun, T[] rarr)
{
  auto n = rarr.length;
  auto arr = new T[n];
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  foreach(i; taskPool.parallel(iota(n)))
    arr[i] = fun(rarr[i]);
  sw.stop();
  return cast(double)(sw.peek.total!"nsecs"/1000_000_000.0);
}

auto benchOne(T, T lower, T upper, alias F)(F!T fun, long[] n)
{
  auto times = new double[n.length];
  foreach(i; 0..n.length)
  {
    double[3] _times;
    auto rarr = rand!(T, lower, upper)(n[i]);
    foreach(ref t; _times)
    {
      t = applyOne(fun, rarr);
    }
    times[i] = sum(_times[])/_times.length;
    version(verbose)
    {
      writeln("Average time for n = ", n[i], ", ", times[i], " seconds.");
      writeln("Detailed times: ", _times, "\n");
    }
  }
  return tuple(F.stringof[0..($-3)], T.stringof, n, times);
}

auto runBenchOne(T, FS)(FS funcs, long[] n)
{
  enum _range = getRange!(typeof(funcs[0]).stringof, T);
  version(verbose)
  {
    writeln("Running benchmarks for ", funcs[0]);
  }
  writeln("Range: ", _range);
  auto tmp = benchOne!(T, _range[0], _range[1])(funcs[0], n);
  alias R = typeof(tmp);
  R[] results = new R[funcs.length];
  results[0] = tmp;
  static foreach(i; 1..funcs.length)
  {{
    enum range = getRange!(getClassTemplate!(typeof(funcs[i])));
    results[i] = benchOne!(T, range[0], range[1])(funcs[i], n);
    version(verbose)
    {
      writeln("Running benchmarks for ", funcs[i]);
      writeln("Range: ", range);
    }
  }}
  return results;
}

/*
  For fmin and fmax
*/
auto applyTwoA(T, alias F)(F!T fun, T[] rarr)
{
  auto n = rarr.length;
  auto arr = new T[n];
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  //for(size_t i = 0; i < (n - 1); ++i)
  foreach(i; taskPool.parallel(iota(n - 1)))
    arr[i] = fun(rarr[i], rarr[i + 1]);
  sw.stop();
  return cast(double)(sw.peek.total!"nsecs"/1000_000_000.0);
}

auto benchTwoA(T, T lower, T upper, alias F)(F!T fun, long[] n)
{
  auto times = new double[n.length];
  foreach(i; 0..n.length)
  {
    double[3] _times;
    auto rarr = rand!(T, lower, upper)(n[i] + 1);
    foreach(ref t; _times)
    {
      t = applyTwoA(fun, rarr);
    }
    times[i] = sum(_times[])/_times.length;
    version(verbose)
    {
      writeln("Average time for n = ", n[i], ", ", times[i], " seconds.");
      writeln("Detailed times: ", _times, "\n");
    }
  }
  return tuple(F.stringof[0..($ - 3)], T.stringof, n, times);
}

auto runBenchTwoA(T, FS)(FS funcs, long[] n)
{
  enum _range = getRange!(typeof(funcs[0]).stringof, T);
  version(verbose)
  {
    writeln("Running benchmarks for ", funcs[0]);
    writeln("Range: ", _range);
  }
  auto tmp = benchTwoA!(T, _range[0], _range[1])(funcs[0], n);
  alias R = typeof(tmp);
  R[] results = new R[funcs.length];
  results[0] = tmp;
  static foreach(i; 1..funcs.length)
  {{
    enum range = getRange!(getClassTemplate!(typeof(funcs[i])));
    results[i] = benchTwoA!(T, range[0], range[1])(funcs[i], n);
    version(verbose)
    {
      writeln("Running benchmarks for ", funcs[i]);
      writeln("Range: ", range);
    }
  }}
  return results;
}

/*
  For pow function
*/
auto applyTwoB(T, alias F)(F!T fun, T[] rarr, T exponent)
{
  auto n = rarr.length;
  auto arr = new T[n];
  auto sw = StopWatch(AutoStart.no);
  sw.start();
  //foreach(size_t i, el; rarr)
  foreach(i; taskPool.parallel(iota(n)))
    arr[i] = fun(rarr[i], exponent);
  sw.stop();
  return cast(double)(sw.peek.total!"nsecs"/1000_000_000.0);
}

auto benchTwoB(T, T lower, T upper, alias F)(F!T fun, long[] n, T exponent)
{
  auto times = new double[n.length];
  foreach(i; 0..n.length)
  {
    double[3] _times;
    auto rarr = rand!(T, lower, upper)(n[i]);
    foreach(ref t; _times)
    {
      t = applyTwoB(fun, rarr, exponent);
    }
    times[i] = sum(_times[])/_times.length;
    version(verbose)
    {
      writeln("Average time for n = ", n[i], ", ", times[i], " seconds.");
      writeln("Detailed times: ", _times, "\n");
    }
  }
  return tuple(F.stringof[0..($ - 3)], T.stringof, exponent, n, times);
}

/*
  This time we run this benchmark for only one function but multiple
  exponents
*/
auto runBenchTwoB(F, A: T[N], T, alias N)(F func, long[] n, A exponents)
{
  enum range = getRange!(typeof(func).stringof, T);
  version(verbose)
  {
    writeln("Running benchmarks for ", func, ", exponent: ", exponents[0]);
    writeln("Range: ", range);
  }
  auto tmp = benchTwoB!(T, range[0], range[1])(func, n, exponents[0]);
  alias R = typeof(tmp);
  R[] results = new R[N];
  results[0] = tmp;
  static foreach(i; 1..N)
  {
    results[i] = benchTwoB!(T, range[0], range[1])(func, n, exponents[i]);
    version(verbose)
    {
      writeln("Running benchmarks for ", func, ", exponent: ", exponents[i]);
    }
  }
  return results;
}

void writeRow(File file, string[] row)
{
  string line = "";
  foreach(i; 0..(row.length - 1))
    line ~= row[i] ~ ",";
  line ~= row[row.length - 1] ~ "\n";
  file.write(line);
  return;
}


void runMathBench(T)(string mathLib)
{
  auto n = [100_000L, 500_000L, 1000_000L, 5000_000L, 
            10_000_000L, 100_000_000L];
  auto tupleFuncOne = tuple(new Cos!(T), new Exp!(T), new Exp2!(T), new Fabs!(T),
                     new Log!(T), new Log10!(T),new Log2!(T), new Round!(T),
                     new Sin!(T), new Sqrt!(T));
  
  auto results = runBenchOne!(T)(tupleFuncOne, n);
  auto tupleFuncTwoA = tuple(new Fmax!(T), new Fmin!(T));
  results ~= runBenchTwoA!(T)(tupleFuncTwoA, n);
  
  T[17] exponents = [cast(T)-1.0, cast(T)-0.75, cast(T)-0.5, cast(T)-0.25, cast(T)0.0,
                     cast(T)0.25, cast(T)0.5,   cast(T)0.75, cast(T)1.0,   cast(T)1.25,
                     cast(T)1.5,  cast(T)1.75,  cast(T)2.0,  cast(T)2.25,  cast(T)2.5,  
                     cast(T)2.75, cast(T)3.0];
  auto resultsTwoB = runBenchTwoB(new Pow!(T), n, exponents);

  string[][] table;
  foreach(result; results)
  {
    foreach(i; 0..n.length)
    {
      table ~= [mathLib, result[0], result[1], "", to!(string)(result[2][i]), to!(string)(result[3][i])];
    }
  }
  foreach(result; resultsTwoB)
  {
    foreach(i; 0..n.length)
    {
      table ~= [mathLib, result[0], result[1], to!(string)(result[2]), to!(string)(result[3][i]), to!(string)(result[4][i])];
    }
  }
  
  version(fastmath)
  {
    auto file = File("../fastmathdata/" ~ mathLib ~ "_" ~ T.stringof ~ ".csv", "w");
  }else{
    auto file = File("../data/" ~ mathLib ~ "_" ~ T.stringof ~ ".csv", "w");
  }
  foreach(row; table)
    file.writeRow(row);
  return;
}
