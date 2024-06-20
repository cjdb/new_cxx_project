#include <format>
#include <string>
#include <string_view>

std::string make_fancy(std::string_view const message)
{
	return std::format("fancy {}", message);
}
