@:headerInclude("CivetC.h")
function main() {
    trace("123");
    CivetC.get("/hello",(con,id)->{
        CivetC.send(id,"hello");
    });
    CivetC.get("/world",(con,id)->{
        CivetC.send(id, "world");
    });
    CivetC.get("/testgc",(con,id)->{
        //var d=Date.now();
        var as_str="123";//d.toString();
        CivetC.send(id, 'NOW IS $as_str');
    });
    CivetC.main(8086);
}
