#include <civetweb.h>
#include <cstdint>

struct req_info {
    mg_connection *conn;
    uint32_t uuid;
};