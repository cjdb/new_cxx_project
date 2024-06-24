#include <check.hpp>
#include <greeter.hpp>

int main()
{
	CHECK(greet("Hello", "world") == "Hello, world!");
}
