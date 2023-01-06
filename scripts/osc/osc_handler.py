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

    def parseAddr(self, addr: str, index: int):
        number = ""
        i = index
        while addr[i] != "/":
            number += addr[i]
            i += 1
        return int(number)

    def Sync(self, addr: str, data):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"triggered address :{addr} ; FuncGen {funcGen} selected")
            # self.driver.selectFuncGen(funcGen)
            # TODO : I don't know what it is supposed to do
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Harmonic(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setScale(0, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Frequency(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"triggered address :{addr} ; FuncGen {funcGen} selected; f : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setFrequency(data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Scale(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"triggered address :{addr} ; FuncGen {funcGen} selected")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setScale(1, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Phase(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setPhaseOffset(1, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Offset(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.setPhaseOffset(0, data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Waveform(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # self.driver.changeWaveform(data)
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Blanking_Width(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
        try:
            print(f"{addr} FuncGen {funcGen} selected, new value : {data}")
            # self.driver.selectFuncGen(funcGen)
            # TODO : I don't know what it is supposed to do
            # self.driver.deselectFuncGen()
        except:
            self.client.send_message("/error", "")
        return

    def Blanking_Phase(self, addr: str, data: List[Any]):
        funcGen = self.parseAddr(addr, 11)
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

    def Modifier(self, addr: str, data: List[Any]):
        channel = self.parseAddr(addr, 8)
        b1 = data[0]
        b2 = data[1]
        try:
            print(f"triggered address :{addr} ; channel : {channel}; b : {b1} , {b2}")
            #TODO : I don't know what to do with that
        except:
            self.client.send_message("/error", "")

    def Connection(self, addr: str, data: List[Any]):
        channel = self.parseAddr(addr, 8)
        f1 = data[0]
        f2 = data[1]
        f3 = data[2]
        try:
            print(f"triggered address :{addr} ; channel : {channel} ; f : {f1} , {f2} , {f3}")
            #TODO : I don't know what to do with that
        except:
            self.client.send_message("/error", "")