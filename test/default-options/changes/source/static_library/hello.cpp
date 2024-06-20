#include <fanciful.hpp>
#include <greeter.hpp>
#include <print>

int main()
{
	std::println("{}", make_fancy(greet("Hello", "world")));
}
