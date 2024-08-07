#include "Main.h"

#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include "civetweb.h"
#include <CivetC.h>

using namespace std::string_literals;

void _Main::Main_Fields_::main() {
	std::cout << "Main.hx:3: 123"s << std::endl;
	CivetC::get("/hello"s, [&](const Star<mg_request_info>* con, uint32_t id) mutable {
		CivetC::send(id, "hello"s);
	});
	CivetC::get("/world"s, [&](const Star<mg_request_info>* con, uint32_t id) mutable {
		CivetC::send(id, "world"s);
	});
	CivetC::get("/testgc"s, [&](const Star<mg_request_info>* con, uint32_t id) mutable {
		std::string as_str = "123"s;

		CivetC::send(id, "NOW IS "s + as_str);
	});
	CivetC::main(8086);
}
