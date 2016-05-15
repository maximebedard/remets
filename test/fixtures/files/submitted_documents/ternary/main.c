#include <stdio.h>

unsigned int fib(unsigned int n){
  return (n < 2) ? n : fib(n - 1) + fib(n - 2);
}

int main(int argc, const char* argv[])
{
  printf(fib(7));
}
