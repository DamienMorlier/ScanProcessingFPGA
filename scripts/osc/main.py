from typing import List, Any
import pythonosc.dispatcher as dispatcher
import pythonosc.osc_server as osc_server

def set_func_gen_freq(address: str, *args: List[Any]):
    if len(args) != 1 or args[0] is not float:
        return
    
    print("Hello, damnation!")

def func_gen_reset(address: str, *args: List[Any]):
    print("FUNC GEN RESET!")

def default_handler(address: str, *args: List[Any]):
    print("DEFUALT")

def main():
    disp = dispatcher.Dispatcher()
    disp.map("/func_gen/0/set_freq", set_func_gen_freq)
    disp.map("/func_gen/0/reset", func_gen_reset)
    disp.set_default_handler(default_handler)
    
    server = osc_server.BlockingOSCUDPServer(("127.0.0.1", 1337), disp)
    server.serve_forever()

if __name__ == "__main__":
    main()