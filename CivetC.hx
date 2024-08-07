import cxx.Const;
#if cpp
import cpp.UInt32;
import cpp.StdString;
import cpp.ConstCharStar;
import cpp.Star;
#end
using StringTools;
#if cxx
import cxx.num.UInt32;
import CxxConvert.ConstCharStar;
import CxxConvert.Star;
import CxxConvert.StdString;
#end
@:include("civetweb.h")
//@:include("civet_native.cpp")
//@:include("../../civetweb/include/civetweb.h")
#if cpp
@:cppNamespaceCode('
#include "../../civet_native.cpp"
')
#end
#if cxx
@:cppInclude('../../channel.hpp')
@:cppInclude('../../civet_native.cpp')
#end
#if windows
@:buildXml("
<target id='haxe'>
<flag value='/DEBUG' />
<flag value='-I${this_dir}' />
<flag value='-I${this_dir}/civetweb/include' />
<flag value='${haxelib:civetc}/civetweb/VisualStudio/ex_embedded_c/x64/Debug/civetweb.obj' />
</target>
<compiler>

<flag value='-I${haxelib:civetc}' />
<flag value='-I${haxelib:civetc}/civetweb/include' />
</compiler>

")
#end
#if linux
@:buildXml("
<target id='haxe'>
<flag value='-fpermissive' />
<flag value='-g' />
<flag value='-I${this_dir}' />
<flag value='-I${this_dir}/civetweb/include' />
<flag value='../civetweb/out/src/civetweb.o' />
</target>
<compiler>

<flag value='-I${haxelib:civetc}' />
<flag value='-I${haxelib:civetc}/civetweb/include' />
</compiler>

")
//<lib name='../civetweb/VisualStudio/ex_embedded_c/x64/Debug/civetweb.obj'/>
#end
class CivetC {
    static var handlers=new Array<PathHandler>();
    public static function main(port:Int) {
        for (k=>v in handlers){
            trace(k,v);
        }
        #if cpp
        StartWeb(Std.string(port));
        #end
        #if cxx
        StartWeb(new StdString(Std.string(port)));
        #end
    }
    public static function get(url,hand){
        handlers.push({path:url,handler: hand});
        handlers.sort((a,b)->a.path.length-b.path.length);
    }
    public static var log=false;
    static function makelog(what) {
        if (log){
            trace(what);
        }
    }
    static function respond(conn:Const<Star<Connection>>,id:UInt32){
        var req_info:Star<RequestInfo>=mg_get_request_info(conn);
        makelog("Handling: "+req_info);
        for (kv in handlers){
            var k=kv.path;
            var v=kv.handler;
            makelog("Testing: "+k);
            if (req_info.request_uri.toString().startsWith(k)){
                v(req_info,id);
            }
        }
        return "404 not found from haxe";
    }
    @:native("_StartWeb")
    extern static function StartWeb(c:ConstCharStar):Void;
    @:native("mg_get_request_info")
    extern static function mg_get_request_info(c:Star<Connection>):Const<Star<RequestInfo>>;
    @:native("unlock")
    extern static function unlock(id:UInt32,response:StdString):Void;

    public static function send(id,response:String) {
        trace("responding");
        unlock(id,StdString.ofString(response));
    }
}


typedef PathHandler ={
    path:String,
    handler:(Const<Star<RequestInfo>>,UInt32)->Void,
}


