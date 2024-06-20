#ifndef PLUGIN_HANDLER
#define PLUGIN_HANDLER

#include <cassert>
#include <dlfcn.h>
#include <functional>
#include <memory>
#include <string_view>
#include <utility>

class dynamic_library {
public:
	dynamic_library(std::string_view const name)
	: library_(dlopen(name.data(), RTLD_LAZY | RTLD_DEEPBIND), dlclose)
	{
		assert(library_ != nullptr);
	}

	template<class T>
	class dynamic_function {
	public:
		explicit dynamic_function(T* const function)
		: function_(function)
		{}

		template<class... Args>
		decltype(auto) operator()(Args&&... args)
		{
			return std::invoke(function_, std::forward<Args>(args)...);
		}
	private:
		T* function_;
	};

	template<class T>
	dynamic_function<T> load_function(std::string_view const name)
	{
		auto function = reinterpret_cast<T*>(dlsym(library_.get(), name.data()));
		assert(function != nullptr);
		return dynamic_function(function);
	}
private:
	std::unique_ptr<void, int (*)(void*)> library_;
};

#endif // PLUGIN_HANDLER
