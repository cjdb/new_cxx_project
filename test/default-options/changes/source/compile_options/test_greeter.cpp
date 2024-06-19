#include <cassert>
#include <greeter.hpp>
#include <string_view>

int main()
{
	assert(greet("Hello", "world") == "Hello, world!");
}
