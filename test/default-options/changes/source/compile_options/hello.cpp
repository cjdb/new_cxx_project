#include <greeter.hpp>
#include <print>
#include <string_view>

int main(int, char**, char**)
{
	std::println("{}", greet("Hello", "world"));
}
