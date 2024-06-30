#include <check.hpp>
#include <greeter.hpp>

int main()
{
	auto message = greet("Hello", "world");
	++message;
	CHECK(*message == "Hello, world!");
}
