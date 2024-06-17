#ifndef GREETER_HPP
#define GREETER_HPP

#include <string>

#if defined(RETURN_TYPE)
using greet_result_t = std::string;
#endif

greet_result_t greet(std::string_view greeting, std::string_view name);

#endif // GREETER_HPP
