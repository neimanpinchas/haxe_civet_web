//@:structAccess
@:native("cpp::Struct<mg_request_info>")
//@:include("../../civetweb/include/civetweb.h")
@:include("civetweb.h")
extern class RequestInfo {
    public var request_method:cpp.ConstCharStar;   
    public var request_uri:cpp.ConstCharStar;   
}