#include <greeter.hpp>
#include <string>
#include <string_view>

std::string greet_impl(std::string_view, std::string_view);

std::string greet(std::string_view const greeting, std::string_view const name)
{
	return greet_impl(greeting, name);
}
