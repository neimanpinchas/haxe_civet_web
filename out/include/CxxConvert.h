#pragma once

#include <memory>
#include <string>

using ConstCharStar = const char*;


namespace _CxxConvert {

class StdString_Impl_ {
public:
	static const char* _new(std::string s);
	static const char* ofString(std::string s);
	static ConstCharStar toConstCharStar(const char* this1);
};

}


template<typename T>
using Star = T;
