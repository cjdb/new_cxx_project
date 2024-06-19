#include <format>
#include <greeter.hpp>
#include <string>
#include <string_view>

greet_result_t greet(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}
