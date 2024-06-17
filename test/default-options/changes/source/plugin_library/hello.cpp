#include <cassert>
#include <dlfcn.h>
#include <greeter.hpp>
#include <print>

int main()
{
	auto greeter = dlopen("./libgreeter_plugin.so", RTLD_LAZY | RTLD_DEEPBIND);
	assert(greeter != nullptr);
	auto greet = reinterpret_cast<decltype(::greet)*>(dlsym(greeter, "greet"));
	assert(greet);
	std::println("{}", greet("Hello", "world"));
	dlclose(greeter);
}
