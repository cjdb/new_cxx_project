#include <format>
#include <string>
#include <string_view>

#ifndef A_LIBRARY_MACRO
#	error A_LIBRARY_MACRO was not defined
#endif

#if not defined(ANOTHER_LIBRARY_MACRO)
#	error ANOTHER_LIBRARY_MACRO was not defined
#elif ANOTHER_LIBRARY_MACRO != 648
#	error ANOTHER_LIBRARY_MACRO != 648
#endif

std::string greet(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}
