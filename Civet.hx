import cpp.Pointer;
import cpp.RawPointer;
import cpp.ConstCharStar;
import haxe.ds.Vector;
import cpp.Stdio;
import cpp.Stdlib;

@:cppNamespaceCode('

')

@:native("mg_connection")
extern class MgConnection {

}

@:include("./civetweb/include/civetweb.h")
@:include("./civetweb/include/CivetServer.h")
extern class CivetHandler {
    public function new():Void;
    
}

@:native("mg_printf")
@:overload(function(c:Pointer<MgConnection>,s:String,d:Dynamic):Void{})
extern function mg_printf(c:Pointer<MgConnection>,s:String):Void;
@:include("./civetweb/include/CivetServer.h")
extern class CivetServer {
    public function new(i:StdVectorString):Void;

    public function addHandler(s:String, h_ex:CivetHandler):Void;
}

@:include("./civetweb/include/CivetServer.h")
//@:native("ExampleHandler : public CivetHandler")
@:unreflective
class ExampleHandler extends CivetHandler
{
  public
	function 
	handleGet(server:CivetServer , conn : Pointer<MgConnection>)
	{
		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "+
		          "text/html\r\nConnection: close\r\n\r\n");
		mg_printf(conn, "<html><body>\r\n");
		mg_printf(conn,
		          "<h2>This is an example text from a C++ handler</h2>\r\n");
		mg_printf(conn,
		          "<p>To see a page from the A handler <a "+
		          "href=\"a\">click here</a></p>\r\n");
		mg_printf(conn,
                  "<form action=\"a\" method=\"get\">"+
                  "To see a page from the A handler with a parameter "+
                  "<input type=\"submit\" value=\"click here\" "+
                  "name=\"param\" \\> (GET)</form>\r\n");
        mg_printf(conn,
                  "<form action=\"a\" method=\"post\">"+
                  "To see a page from the A handler with a parameter "+
                  "<input type=\"submit\" value=\"click here\" "+
                  "name=\"param\" \\> (POST)</form>\r\n");
		mg_printf(conn,
		          "<p>To see a page from the A/B handler <a "+
		          "href=\"a/b\">click here</a></p>\r\n");
		mg_printf(conn,
		          "<p>To see a page from the *.foo handler <a "+
		          "href=\"xy.foo\">click here</a></p>\r\n");
		mg_printf(conn,
		          "<p>To see a page from the WebSocket handler <a "+
		          "href=\"ws\">click here</a></p>\r\n");
		mg_printf(conn,
		          "<p>To exit <a href=\"%s\">click here</a></p>\r\n",
		          "http://example.com/exit");
		mg_printf(conn, "</body></html>\r\n");
		return true;
	}
}
/*

class ExitHandler extends CivetHandler
{
  public:
	bool
	handleGet(CivetServer *server, struct mg_connection *conn)
	{
		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "
		          "text/plain\r\nConnection: close\r\n\r\n");
		mg_printf(conn, "Bye!\n");
		exitNow = true;
		return true;
	}
};

class AHandler extends CivetHandler
{
  private:
	bool
	handleAll(const char *method,
	          CivetServer *server,
	          struct mg_connection *conn)
	{
		std::string s = "";
		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "
		          "text/html\r\nConnection: close\r\n\r\n");
		mg_printf(conn, "<html><body>");
		mg_printf(conn, "<h2>This is the A handler for \"%s\" !</h2>", method);
		if (CivetServer::getParam(conn, "param", s)) {
			mg_printf(conn, "<p>param set to %s</p>", s.c_str());
		} else {
			mg_printf(conn, "<p>param not set</p>");
		}
		mg_printf(conn, "</body></html>\n");
		return true;
	}

  public:
	bool
	handleGet(CivetServer *server, struct mg_connection *conn)
	{
		return handleAll("GET", server, conn);
	}
	bool
	handlePost(CivetServer *server, struct mg_connection *conn)
	{
		return handleAll("POST", server, conn);
	}
};

class ABHandler extends CivetHandler
{
  public:
	bool
	handleGet(CivetServer *server, struct mg_connection *conn)
	{
		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "
		          "text/html\r\nConnection: close\r\n\r\n");
		mg_printf(conn, "<html><body>");
		mg_printf(conn, "<h2>This is the AB handler!!!</h2>");
		mg_printf(conn, "</body></html>\n");
		return true;
	}
};

class FooHandler extends CivetHandler
{
  public:
	bool
	handleGet(CivetServer *server, struct mg_connection *conn)
	{
		/ * Handler may access the request info using mg_get_request_info * /
		const struct mg_request_info *req_info = mg_get_request_info(conn);

		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "
		          "text/html\r\nConnection: close\r\n\r\n");

		mg_printf(conn, "<html><body>\n");
		mg_printf(conn, "<h2>This is the Foo GET handler!!!</h2>\n");
		mg_printf(conn,
		          "<p>The request was:<br><pre>%s %s HTTP/%s</pre></p>\n",
		          req_info->request_method,
		          req_info->request_uri,
		          req_info->http_version);
		mg_printf(conn, "</body></html>\n");

		return true;
	}
	bool
	handlePost(CivetServer *server, struct mg_connection *conn)
	{
		/* Handler may access the request info using mg_get_request_info * /
		const struct mg_request_info *req_info = mg_get_request_info(conn);
		long long rlen, wlen;
		long long nlen = 0;
		long long tlen = req_info->content_length;
		char buf[1024];

		mg_printf(conn,
		          "HTTP/1.1 200 OK\r\nContent-Type: "
		          "text/html\r\nConnection: close\r\n\r\n");

		mg_printf(conn, "<html><body>\n");
		mg_printf(conn, "<h2>This is the Foo POST handler!!!</h2>\n");
		mg_printf(conn,
		          "<p>The request was:<br><pre>%s %s HTTP/%s</pre></p>\n",
		          req_info->request_method,
		          req_info->request_uri,
		          req_info->http_version);
		mg_printf(conn, "<p>Content Length: %li</p>\n", (long)tlen);
		mg_printf(conn, "<pre>\n");

		while (nlen < tlen) {
			rlen = tlen - nlen;
			if (rlen > sizeof(buf)) {
				rlen = sizeof(buf);
			}
			rlen = mg_read(conn, buf, (size_t)rlen);
			if (rlen <= 0) {
				break;
			}
			wlen = mg_write(conn, buf, (size_t)rlen);
			if (wlen != rlen) {
				break;
			}
			nlen += wlen;
		}

		mg_printf(conn, "\n</pre>\n");
		mg_printf(conn, "</body></html>\n");

		return true;
	}

 
};

*/


@:keep
@:unreflective
@:structAccess
@:include('vector')
@:native('std::vector<const char*>')
extern class StdVectorString
{
    @:native('std::vector<const char*>')
    static function create() : StdVectorString;

    function push_back(_string : ConstCharStar) : Void;

    function data() : RawPointer<ConstCharStar>;

    function size() : Int;
}

function mg_init_library(i:Int){
    untyped __global__.mg_init_library(i);
}; 
function mg_exit_library(){
    untyped __global__.mg_exit_library();
}; 
function main()
{
	mg_init_library(0);
	
	var cpp_options=StdVectorString.create();
    

	// CivetServer server(options); // <-- C style start
    
	var server=Pointer.addressOf(new CivetServer(cpp_options)); // <-- C++ style start

	var h_ex=new ExampleHandler();
	server.ref.addHandler("/example", h_ex);
/*
	ExitHandler h_exit;
	server.addHandler(EXIT_URI, h_exit);

	AHandler h_a;
	server.addHandler("/a", h_a);

	ABHandler h_ab;
	server.addHandler("/a/b", h_ab);

	WsStartHandler h_ws;
	server.addHandler("/ws", h_ws);


	/* This handler will handle "everything else", including
	 * requests to files. If this handler is installed,
	 * NO_FILES should be set. * /
	FooHandler h_foo;
	server.addHandler("", h_foo);
	trace("See a page from the \"all\" handler at http://localhost:%s/\n", 8088);
    
    
    
	trace("Run example at http://localhost:%s%s\n", PORT, EXAMPLE_URI);
	trace("Exit at http://localhost:%s%s\n", PORT, EXIT_URI);
    */

	while (!exitNow) {
        Sys.sleep(1000);
    }

	trace("Bye!\n");
	mg_exit_library();

	return 0;


}

var exitNow=false;
