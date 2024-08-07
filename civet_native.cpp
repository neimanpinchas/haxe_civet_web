#include <civetweb.h>
#include <channel.hpp>
#include <cstdio>
#include <iostream>
#include <thread>
#include <mutex>
#include <map>
#include <future>
#include <types.hpp>
#include <tuple>
#ifdef _WIN32
#include <windows.h>
#endif

using namespace std;
typedef string message;
extern "C"
{
    static std::map<unsigned int, std::promise<message> *> waiters;
    auto _pair = channel<req_info>();
    auto &tx = std::get<0>(_pair);
    auto &rx = std::get<1>(_pair);
    void unlock(int id, message response)
    {
        cout << "responding" << id << endl;
        cout << "responding" << response << endl;
        waiters[id]->set_value(response);
    }

    void pass_to_haxe(Receiver<req_info> &&reciever)
    {
        int inTop = 0;
        #ifdef cpp
        hx::SetTopOfStack((int *)&inTop, true);
        #endif

        req_info next;
        while (true)
        {
            try {
                cout << "reading next from channel" << endl;
                #ifdef cpp
                hx::EnterGCFreeZone();
                #endif
                reciever.recv(next);
                #ifdef cpp
                hx::TryExitGCFreeZone();
                #endif
                cout << "done reading next from channel" << endl;
                #ifdef cpp
            CivetC_obj::respond(next.conn, next.uuid);
            #endif
                #ifdef cxx
            CivetC::respond(next.conn, next.uuid);
            #endif
            } catch(exception ex){
                cerr << "error in rx loop" << ex.what() << endl;
            }
        }
    }

    static std::atomic<std::uint32_t> uid{0};
    static int
    handler(struct mg_connection *conn, void *ignored)
    {
// printf("responding");
// const char *msg = "Hello world";
#ifdef direct_haxe
        hx::EnterGCFreeZone();
#endif
        cout << "calling haxe to respond" << endl;
        auto uuid = ++uid;
        tx.send(req_info{conn = conn, uuid = uuid});

        std::promise<message> *m = new promise<message>();
        std::future<message> f = m->get_future();
        waiters[uuid] = m;
        auto msg = f.get();
#ifdef direct_haxe
        hx::TryExitGCFreeZone();
#endif
        unsigned long len = (unsigned long)msg.length();

        mg_send_http_ok(conn, "text/plain", len);

        mg_write(conn, msg.c_str(), len);

        return 200; /* HTTP state 200 = OK */
    }

    static int
    civetc_handler(struct mg_connection *conn, void *ignored)
    {
        printf("responding\n");
        const char *msg = "Hello from civetc";
        unsigned long len = (unsigned long)strlen(msg);

        mg_send_http_ok(conn, "text/plain", len);

        mg_write(conn, msg, len);

        return 200; /* HTTP state 200 = OK */
    }

    void *init_thread(const struct mg_context *ctx, int thread_type)
    {
        cout << "new thread type " << thread_type << endl;
#ifdef direct_haxe
        if (thread_type == 1)
        {
            int inTop = 0;
            hx::SetTopOfStack((int *)&inTop, true);
        }
        cout << "done initing thread" << endl;

#endif
        return (void *)0;
    }

    int
    log_message(const struct mg_connection *conn, const char *message)
    {
        cout << message << endl;
        return 1;
    }

    void _StartWeb(const char *port)
    {
        /* Server context handle */
        struct mg_context *ctx;

        static struct mg_callbacks cb;

        cb.init_thread = init_thread;
        cb.log_message = log_message;

        /* Initialize the library */
        mg_init_library(0);

        cout << "will listen on port " << port << endl;

        const char *options[] = {
            "listening_ports", "8086",
            //"num_threads", "5",
            //"prespawn_threads", "5",
            NULL};

        /* Start the server */
        ctx = mg_start(&cb, 0, options);

        std::thread t1(pass_to_haxe, std::move(rx));

        char *text = "Hello world";

        /* Add some handler */
        mg_set_request_handler(ctx, "/hello", civetc_handler, text);
        mg_set_request_handler(ctx, "/", handler, text);
        while (1)
        {
            std::cout << ("CTRL+C to quit") << endl;
#ifdef _WIN32
            Sleep(10000);
#else
            sleep(10);
#endif
        }
        /* Stop the server */
        mg_stop(ctx);

        /* Un-initialize the library */
        mg_exit_library();
    }
}
