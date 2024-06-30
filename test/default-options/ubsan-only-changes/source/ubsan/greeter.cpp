#include <cstdint>
#include <format>
#include <string>
#include <string_view>

std::string greet(std::string_view const greeting, std::string_view const name)
{
	auto k = 0x7f'ff'ff'ff;
	k += static_cast<int>(name.size());
	return std::format("{}, {}!", greeting, name.substr(0, static_cast<std::size_t>(k)));
}
