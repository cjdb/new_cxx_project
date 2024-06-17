#ifndef GREETER_HPP
#define GREETER_HPP

#include <format>
#include <string>

inline std::string greet(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}

#endif // GREETER_HPP
