#include <greeter.hpp>
#include <make_fancy.hpp>
#include <print>

int main()
{
	std::println("{}", make_fancy(greet("Hello", "world")));
}
