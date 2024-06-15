#include "greeter.hpp"
#include <print>

#ifndef AN_EXE_MACRO
#	error AN_EXE_MACRO was not defined
#endif

#if not defined(ANOTHER_EXE_MACRO)
#	error ANOTHER_EXE_MACRO was not defined
#elif ANOTHER_EXE_MACRO != 56
#	error ANOTHER_EXE_MACRO != 56
#endif

int main()
{
	std::println("{}", greet("Hello", "world"));
}
