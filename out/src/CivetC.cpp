#include "CivetC.h"

#include <algorithm>
#include <deque>
#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include "../../channel.hpp"
#include "../../civet_native.cpp"
#include "_AnonStructs.h"
#include "civetweb.h"
#include "cxx_DynamicToString.h"
#include "CxxConvert.h"
#include "haxe_Log.h"
#include "Std.h"
#include "StringTools.h"

using namespace std::string_literals;

std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> CivetC::handlers = std::make_shared<std::deque<std::shared_ptr<PathHandler>>>();

bool CivetC::log = false;

void CivetC::main(int port) {
	std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> _this = CivetC::handlers;
	int _g_current = 0;

	while(_g_current < (int)(_this->size())) {
		std::shared_ptr<PathHandler> _g_value;
		int _g_key = 0;

		_g_value = (*_this)[_g_current];
		_g_key = _g_current++;

		int k = _g_key;
		std::shared_ptr<PathHandler> v = _g_value;

		haxe::Log::trace(k, haxe::shared_anon<haxe::PosInfos>("CivetC"s, "CivetC.hx"s, 65, "main"s, std::make_shared<std::deque<haxe::DynamicToString>>(std::deque<haxe::DynamicToString>{ v })));
	};

	_StartWeb(_CxxConvert::StdString_Impl_::_new(Std::string(port)));
}

void CivetC::get(std::string url, std::function<void(const Star<mg_request_info>*, uint32_t)> hand) {
	{
		std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> _this = CivetC::handlers;

		_this->push_back(haxe::shared_anon<PathHandler>(hand, url));
	};
	{
		std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> _this = CivetC::handlers;
		std::function<int(std::shared_ptr<PathHandler>, std::shared_ptr<PathHandler>)> f = [&](std::shared_ptr<PathHandler> a, std::shared_ptr<PathHandler> b) mutable {
			return (int)(a->path.size() - b->path.size());
		};

		std::sort(_this->begin(), _this->end(), [&](std::shared_ptr<PathHandler> a, std::shared_ptr<PathHandler> b) mutable {
			return f(a, b) < 0;
		});
	};
}

void CivetC::makelog(haxe::DynamicToString what) {
	if(CivetC::log) {
		haxe::Log::trace(what, haxe::shared_anon<haxe::PosInfos>("CivetC"s, "CivetC.hx"s, 81, "makelog"s));
	};
}

std::string CivetC::respond(const Star<mg_connection>* conn, uint32_t id) {
	Star<mg_request_info>* req_info = mg_get_request_info(conn);
	std::string tempString = std::string(req_info);

	CivetC::makelog("Handling: "s + (tempString));

	int _g = 0;
	std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> _g1 = CivetC::handlers;

	while(_g < (int)(_g1->size())) {
		std::shared_ptr<PathHandler> kv = (*_g1)[_g];

		++_g;

		std::string k = kv->path;
		std::function<void(const Star<mg_request_info>*, uint32_t)> v = kv->handler;

		CivetC::makelog("Testing: "s + k);

		if(StringTools::startsWith(std::string(req_info->request_uri), k)) {
			v(req_info, id);
		};
	};

	return "404 not found from haxe"s;
}

void CivetC::send(uint32_t id, std::string response) {
	std::cout << "CivetC.hx:105: responding"s << std::endl;
	unlock(id, _CxxConvert::StdString_Impl_::ofString(response));
}
