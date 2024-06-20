#include <format>
#include <make_fancy.hpp>

std::string make_fancy(std::string_view message)
{
	return std::format("fancy {}", message);
}
