#include <check.hpp>
#include <fanciful.hpp>
#include <greeter.hpp>

int main()
{
	CHECK(make_fancy(greet("Hello", "world")) == "fancy Hello, world!");
}
