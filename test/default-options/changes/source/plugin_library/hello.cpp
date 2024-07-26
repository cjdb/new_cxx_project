#include <cassert>
#include <dlfcn.h>
#include <format>
#include <greeter.hpp>
#include <plugin_handler.hpp>
#include <print>

int main(int, char* argv[])
{
	auto const binary_path = std::string_view(argv[0]);
	auto const lib_path = std::format("{}/../lib/libgreeter_plugin.so", binary_path.substr(0, binary_path.rfind('/')));
	auto greeter = dynamic_library(lib_path);
	auto greet = greeter.template load_function<decltype(::greet)>("greet");
	std::println("{}", greet("Hello", "world"));
}
