#include <cassert>
#include <dlfcn.h>
#include <greeter.hpp>

int main()
{
	void* greeter = dlopen("./libgreeter_plugin.so", RTLD_LAZY | RTLD_DEEPBIND);
	assert(greeter != nullptr);
	auto greet = reinterpret_cast<decltype(::greet)*>(dlsym(greeter, "greet"));
	assert(greet != nullptr);
	assert(greet("Hello", "world") == "Hello, world!");
	dlclose(greeter);
}
