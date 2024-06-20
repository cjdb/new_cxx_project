#include <cassert>
#include <dlfcn.h>
#include <greeter.hpp>
#include <plugin_handler.hpp>
#include <print>

int main()
{
	auto greeter = dynamic_library("./libgreeter_plugin.so");
	auto greet = greeter.template load_function<decltype(::greet)>("greet");
	std::println("{}", greet("Hello", "world"));
}
