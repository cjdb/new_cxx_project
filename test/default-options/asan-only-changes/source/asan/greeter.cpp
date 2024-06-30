#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warray-bounds"

#include <format>
#include <string>
#include <string_view>

std::string* greet(std::string_view const greeting, std::string_view const name)
{
	auto result = new std::string();
	*result = std::format("{}, {}!", greeting, name);
	return result;
}
