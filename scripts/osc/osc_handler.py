from typing import List, Any, Callable
import pythonosc.dispatcher as dispatcher
import pythonosc.osc_server as osc_server
from dataclasses import dataclass

from pythonosc import osc_server
import argparse
import math

osc_callback_type = Callable[[str, List[Any], List[Any]], None] | Callable[[str, List[Any]], None]

class OSCHandler:

    def __init__(self, ip_addr: str, port: int):
        self._ip_addr = ip_addr
        self._port = port
        
        self._dispatcher = dispatcher.Dispatcher()

    def subscribe(self, addr: str, cb: osc_callback_type):    
        ## Don't know why, but the wrapper type refuses to cooperate...
        self._dispatcher.map(addr, cb) #type: ignore
        
    def serve(self):
        self._server = osc_server.ThreadingOSCUDPServer((self._ip_addr, self._port), self._dispatcher)
        self._server.serve_forever()

