#include "CxxConvert.h"

#include <string>
#include "_AnonStructs.h"

const char* _CxxConvert::StdString_Impl_::_new(std::string s) {
	const char* this1 = s.c_str();

	return this1;
}

const char* _CxxConvert::StdString_Impl_::ofString(std::string s) {
	return _CxxConvert::StdString_Impl_::_new(s);
}

ConstCharStar _CxxConvert::StdString_Impl_::toConstCharStar(const char* this1) {
	return this1;
}
