#ifndef GREETER_HPP
#define GREETER_HPP

#include <string>

extern "C" std::string greet(std::string_view const greeting, std::string_view const name);

#endif // GREETER_HPP
