#include <format>
#include <string>
#include <string_view>

std::string greet_impl(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}
