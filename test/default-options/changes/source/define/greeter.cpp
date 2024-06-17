#include <format>
#include <greeter.hpp>
#include <string>
#include <string_view>

greet_result_t greet(PARAMETER_TYPE const greeting, PARAMETER_TYPE const name)
{
	return std::format("{}, {}!", greeting, name);
}
