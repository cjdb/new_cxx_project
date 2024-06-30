#ifndef GREETER_HPP
#define GREETER_HPP

#include <string>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type-c-linkage"

extern "C" std::string greet(std::string_view greeting, std::string_view name);

#pragma GCC diagnostic pop

#endif // GREETER_HPP
