#include <cassert>
#include <greeter.hpp>

int main()
{
	assert(greet("Hello", "world") == "Hello, world!");
}
