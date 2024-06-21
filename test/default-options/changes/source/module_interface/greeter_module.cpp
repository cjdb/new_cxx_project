module;
#include <string>

export module greeter;

std::string greet(std::string_view const greeting, std::string_view const name);
