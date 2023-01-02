from typing import List, Any, Callable
import pythonosc.dispatcher as dispatcher
import pythonosc.osc_server as osc_server
from dataclasses import dataclass

from pythonosc import osc_server
from pythonosc.udp_client import SimpleUDPClient

# from ..func_ctrl.FUNC_CTRL import DatapathDriver

osc_callback_type = Callable[[str, List[Any], List[Any]], None] | Callable[[str, List[Any]], None]

class OSCHandler:

    def __init__(self, ip_addr: str, port: int):
        self._ip_addr = ip_addr
        self._port = port
        
        self._dispatcher = dispatcher.Dispatcher()
        # self.driver = DatapathDriver("")
        self.client = SimpleUDPClient("127.0.0.1", 5005)

    def subscribe(self, addr: str, cb: osc_callback_type):    
        ## Don't know why, but the wrapper type refuses to cooperate...
        self._dispatcher.map(addr, cb) #type: ignore
        
    def serve(self):
        self._server = osc_server.ThreadingOSCUDPServer((self._ip_addr, self._port), self._dispatcher)
        self._server.serve_forever()

    def getFuncGen(self, addr: str):
        number = ""
        i = 11
        while addr[i] != "/":
            number += addr[i]
            i += 1
        return int(number)

    def Sync(self, addr: str, data):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # TODO : I don't know what it is supposed to do
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Harmonic(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setScale(0, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Frequency(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setFrequency(data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Scale(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setScale(1, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Phase(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setPhaseOffset(1, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Offset(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setPhaseOffset(0, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Waveform(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.changeWaveform(data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Blanking_Width(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # TODO : I don't know what it is supposed to do
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Blanking_Phase(self, addr: str, data: List[Any]):
        funcGen = self.getFuncGen(addr)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # TODO : I don't know what it is supposed to do
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Matrix(self, addr: str, data: List[Any]):
        channel = f"0x{addr[8]}"
        channel = int(channel, 16)
        funcGen = int(addr[10:])
        try:
            print(f"{addr} : {channel}, {funcGen}, {data}")
            #self.driver.Wiring_Modifier_Param(channel, data, funcGen)
            #self.driver.Wiring_Modifier_Deactive()
        except:
            self.client.send_message("/error", "")
