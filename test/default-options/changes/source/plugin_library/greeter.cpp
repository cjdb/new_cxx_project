#include <format>
#include <string>
#include <string_view>

extern "C" std::string greet(std::string_view const greeting, std::string_view const name)
{
	return std::format("{}, {}!", greeting, name);
}
