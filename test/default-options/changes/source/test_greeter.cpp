#include "greeter.hpp"
#include <cassert>

#ifndef A_TEST_MACRO
#	error A_TEST_MACRO was not defined
#endif

#if not defined(ANOTHER_TEST_MACRO)
#	error ANOTHER_TEST_MACRO was not defined
#elif ANOTHER_TEST_MACRO != 42
#	error ANOTHER_TEST_MACRO != 42
#endif

int main()
{
	assert(greet("Hello", "world") == "Hello, world!");
}
