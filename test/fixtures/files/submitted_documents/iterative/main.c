#include <stdio.h>

unsigned int fib(unsigned int n)
{
  unsigned int i = 0, j = 1, k, t;
  for (k = 1; k <= n; ++k)
  {
    t = i + j;
    i = j;
    j = t;
  }
  return j;
}

int main(int argc, const char* argv[])
{
  printf(fib(7));
}
