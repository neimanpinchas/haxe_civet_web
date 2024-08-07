#pragma once

#include "_AnonStructs.h"
#include "_AnonUtils.h"
#include "civetweb.h"
#include "cxx_DynamicToString.h"
#include "CxxConvert.h"
#include <cstdint>
#include <deque>
#include <functional>
#include <memory>
#include <optional>
#include <string>

// { handler: (cxx.Const<Star<mg_request_info>>, cxx.num.UInt32) -> Void, path: String }
struct PathHandler {

	// default constructor
	PathHandler() {}

	// auto-construct from any object's fields
	template<typename T>
	PathHandler(T o):
		path(haxe::unwrap(o).path){
		handler = [=](const Star<mg_request_info>* , uint32_t ) { return haxe::unwrap(o).handler(, ); };
	}

	// construct fields directly
	static PathHandler make(std::function<void(const Star<mg_request_info>*, uint32_t)> handler, std::string path) {
		PathHandler result;
		result.handler = handler;
		result.path = path;
		return result;
	}

	// fields
	std::function<void(const Star<mg_request_info>*, uint32_t)> handler;
	std::string path;
};


class CivetC {
public:
	static std::shared_ptr<std::deque<std::shared_ptr<PathHandler>>> handlers;
	static bool log;

	static void main(int port);
	static void get(std::string url, std::function<void(const Star<mg_request_info>*, uint32_t)> hand);
	static void makelog(haxe::DynamicToString what);
	static std::string respond(const Star<mg_connection>* conn, uint32_t id);
	static void send(uint32_t id, std::string response);
};

