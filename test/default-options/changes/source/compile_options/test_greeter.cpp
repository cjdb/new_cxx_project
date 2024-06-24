#include <check.hpp>
#include <greeter.hpp>
#include <string_view>

int main()
{
	CHECK(greet("Hello", "world") == "Hello, world!");
}
