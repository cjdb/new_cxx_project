#include <format>
#include <string>

inline std::string make_fancy(std::string_view const message)
{
	return std::format("fancy {}", message);
}
