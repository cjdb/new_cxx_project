#include <check.hpp>
#include <dlfcn.h>
#include <greeter.hpp>
#include <plugin_handler.hpp>

int main()
{
	auto greeter = dynamic_library("./libgreeter_plugin.so");
	auto greet = greeter.template load_function<decltype(::greet)>("greet");
	CHECK(greet("Hello", "world") == "Hello, world!");
}
