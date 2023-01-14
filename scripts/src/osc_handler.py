from typing import List, Any, Callable
import pythonosc.dispatcher as dispatcher
import pythonosc.osc_server as osc_server
from dataclasses import dataclass
import ScanProcessingClass
import functools

from pythonosc import osc_server
from pythonosc.udp_client import SimpleUDPClient

# from ..func_ctrl.FUNC_CTRL import DatapathDriver

osc_callback_type = Callable[[str, List[Any]], None]
        

class OSCHandler:

    def __init__(self, ip_addr: str, port: int, datapath: DatapathDriver):
        self._ip_addr = ip_addr
        self._port = port
        
        self._dispatcher = dispatcher.Dispatcher()
        
        self._datapath_driver = datapath_driver

    def subscribe(self, addr: str, cb: osc_callback_type):    
        ## Don't know why, but the wrapper type refuses to cooperate...
        self._dispatcher.map(addr, cb) #type: ignore
        
    def serve(self):
        self._server = osc_server.ThreadingOSCUDPServer((self._ip_addr, self._port), self._dispatcher)
        self._server.serve_forever()
        
    def subscribe_decorator(self, addr):
        def decorator(func: osc_callback_type):
            
            @functools.wraps(f)
            def wrapper(addr: str, data: List[Any]):
                func(addr, data)
    
            self.subscribe(addr, wrapper)
    
            return wrapper
        return decorator
        