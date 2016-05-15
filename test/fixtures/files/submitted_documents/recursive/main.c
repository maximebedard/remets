#include <stdio.h>

unsigned int fib(unsigned int n){
  if (n < 2)
    return n;
  else
    return fib(n - 1) + fib(n - 2);
}

int main(int argc, const char* argv[])
{
  printf(fib(7));
}
