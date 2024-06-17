#ifndef GREETER_HPP
#define GREETER_HPP

#include <string>
#include <string_view>

#if defined(RETURN_TYPE)
using greet_result_t = std::string;
#endif

greet_result_t greet(PARAMETER_TYPE greeting, PARAMETER_TYPE name);

#endif // GREETER_HPP
