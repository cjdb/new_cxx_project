#include <cassert>
#include <fanciful.hpp>
#include <greeter.hpp>

int main()
{
	assert(make_fancy(greet("Hello", "world")) == "fancy Hello, world!");
}
