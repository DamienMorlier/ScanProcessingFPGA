from typing import List, Any
from osc_handler import OSCHandler
import threading

FUNC_NUMBER = 24

"""
Here is a good guide on how OSC messages work:

http://www.music.mcgill.ca/~gary/306/week9/osc.html
"""

wiring_channel_mapping = {
    "x_mod": 0,
    "y_mod": 1,
    "z_mod": 2,
    "i_mod": 3,
    "x_rot": 4,
    "y_rot": 5,
    "z_rot": 6,
    "zoom": 7,
    "h_pos": 8,
    "v_pos": 9,
    "h_blank": 10,
    "v_blank": 11
}

params = ["sync", "harmonic", "frequency", "scale", "phase", "offset", "waveform", "blanking_width", "blanking_phase"]

global_datapath: DatapathDriver = None
global_osc_handler: OSCHandler = None

def gen_num(addr):
    return int(addr.split('/')[1])

@global_osc_handler.subscribe_decorator("/generator/*/frequency")
def gen_frequency(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    freq = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setFrequency(freq)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_osc_handler.subscribe_decorator("/generator/*/harmonic")
def gen_harmonic(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    harm = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setScale(0, harm)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_osc_handler.subscribe_decorator("/generator/*/scale")
def gen_scale(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    scale = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setScale(1, scale)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_datapath.subscribe_decorator("/generator/*/phase")
def gen_phase(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    phase = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setPhaseOffset(1, phase)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_osc_handler.subscribe_decorator("/generator/*/offset")
def gen_offset(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    offset = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setPhaseOffset(0, offset)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_osc_handler.subscribe_decorator("/generator/*/blanking")
def gen_blanking(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    bl_width, bl_phase = data[0], data[1]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.setBlankingWidth(bl_width)
        global_datapath.setBlankingPhase(bl_phase)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

@global_osc_handler.subscribe_decorator("/generator/*/waveform")
def gen_waveform(addr: str, data: List[Any]):
    funcGen = gen_num(addr)
    wf = data[0]
    try:
        global_datapath.selectFuncGen(funcGen)
        global_datapath.changeWaveform(wf)
        global_datapath.deselectFuncGen()
    except:
        pass
        #self.client.send_message("/error", "")
    return

def wiring_num(addr):
    param = addr.split('/')[1]
    return wiring_channel_mapping(param)

def wiring_gen_num(addr):
    return int(addr.split('/')[2])

@global_datapath.subscribe_decorator("/wiring/*/modifier")
def wiring_modifier(addr: str, data: List[Any]):
    channel = wiring_num(addr)
    b1, b2 = data[0], data[1]
    try:
        global_datapath.paramConf(channel, 0, b1)
        global_datapath.paramConf(channel, 1, b2)
    except:
        pass
        #self.client.send_message("/error", "")
    
@global_datapath.subscribe_decorator("/wiring/generator/*/phase/modifier")
def wiring_gen_phase_modifier(addr: str, data: List[Any]):
    gen_num = wiring_gen_num(addr)
    b1, b2 = data[0], data[1]
    try:
        global_datapath.paramConf(gen_num + 12, 0, b1)
        global_datapath.paramConf(gen_num + 12, 1, b2)
    except:
        pass
        #self.client.send_message("/error", "")

@global_datapath.subscribe_decorator("/wiring/*/connection")
def wiring_connection(addr: str, data: List[Any]):
    channel = wiring_num(addr)
    f1, f2, f3 = data[0], data[1], data[2]
    try:
        global_datapath.Wiring_Modifier_Param(channel, 0, f1)
        global_datapath.Wiring_Modifier_Param(channel, 1, f3)
    except:
        pass
        #self.client.send_message("/error", "")

@global_datapath.subscribe_decorator("/wiring/generator/*/phase/connection")
def wiring_gen_phase_connection(addr: str, data: List[Any]):
    gen_num = wiring_gen_num(addr)
    f1, f2, f3 = data[0], data[1], data[2]
    try:
        global_datapath.Wiring_Modifier_Param(channel + 12, 0, f1)
        global_datapath.Wiring_Modifier_Param(channel + 12, 1, f3)
    except:
        pass
        #self.client.send_message("/error", "")

def osc_thread():
    ## Initialize OSC handling
    assert global_datapath is not None
    
    global_osc_handler = osc_handler = OSCHandler("0.0.0.0", 5005)
    
    paramsHandler = [osc_handler.Sync, osc_handler.Harmonic, osc_handler.Frequency, osc_handler.Scale, osc_handler.Phase, osc_handler.Offset, osc_handler.Waveform, osc_handler.Blanking_Width, osc_handler.Blanking_Phase]
    
    ## Initialize hardware wrappers
    for i in range(len(params)):
        osc_handler.subscribe(f"/generator/*/{params[i]}", paramsHandler[i])
    osc_handler.subscribe("/matrix/*", osc_handler.Matrix)
    osc_handler.subscribe("/wiring/*/modifier", osc_handler.Modifier)
    osc_handler.subscribe("/wiring/*/connection", osc_handler.Connection)
    
    ## Serve 
    osc_handler.serve()
    
def start_osc_thread(datapath):
    global_datapath = datapath
    
    osc_thread = threading.Thread(target=osc_thread)
    osc_thread.start()
    