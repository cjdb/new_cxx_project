module;
#include <string>

export module greeter;

std::string greet(std::string_view greeting, std::string_view name);
