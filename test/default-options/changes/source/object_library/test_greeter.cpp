#include <catch2/catch_test_macros.hpp>
#include <greeter.hpp>

TEST_CASE("hello, world!")
{
	CHECK(greet("Hello", "world") == "Hello, world!");
}
