#include "greeter.hpp"
#include <cassert>

int main()
{
	assert(greet("Hello", "world") == "Hello, world!");
}
