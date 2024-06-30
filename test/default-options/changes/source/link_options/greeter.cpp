#include <format>
#include <greeter.hpp>
#include <string>
#include <string_view>

[[gnu::visibility("default")]] std::string greet(std::string_view greeting, std::string_view name)
{
	return std::format("{}, {}!", greeting, name);
}
