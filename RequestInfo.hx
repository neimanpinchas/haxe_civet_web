#if cpp
import cpp.ConstCharStar;
#else
import CxxConvert.ConstCharStar;
#end
//@:structAccess
#if cpp
@:native("cpp::Struct<mg_request_info>")
#end
//@:include("../../civetweb/include/civetweb.h")
#if cxx
@:include("civetweb.h")
@:native("mg_request_info")
#end
@:keep
extern class RequestInfo {
    public var request_method:ConstCharStar;   
    public var request_uri:ConstCharStar;   
}