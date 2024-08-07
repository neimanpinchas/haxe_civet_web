import haxe.ds.StringMap;
#if cxx
import cxx.num.UInt32;
typedef ConstCharStar=cxx.ConstCharPtr;
typedef Star<T>=cxx.Ptr<T>;
abstract StdString(cxx.ConstCharPtr) to cxx.ConstCharPtr{
    public function new(s:String){
        this=cxx.ConstCharPtr.fromString(s);
    }
    @:from
    public static function ofString(s:String) {
        return new StdString(s);
    }
    @:to
    public function toConstCharStar():ConstCharStar{
        return this;
    }

}
#end
