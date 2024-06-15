#ifndef GREETER_LIB_HPP
#define GREETER_LIB_HPP

#include <format>
#include <string>
#include <string_view>

inline std::string greet(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}

#endif // GREETER_LIB_HPP
