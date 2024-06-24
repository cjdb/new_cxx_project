#ifndef TEST_ASSERT_HPP
#define TEST_ASSERT_HPP

#include <print>

#define CHECK(...)                                                      \
	if (not (__VA_ARGS__)) {                                              \
		std::println(stderr, "error: " #__VA_ARGS__ " evaluated to false"); \
	}

#endif // TEST_ASSERT_HPP
