#include <greeter_impl.hpp>

std::string greet(std::string_view const greeting, std::string_view const name)
{
	return greet_impl(greeting, name);
}
