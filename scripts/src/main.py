import ScanProcessingClass
import time
from pynq import Overlay
from pynq.lib.video import *
from osc_thread import start_osc_thread

DC = 0x1 << 3
TRI = 0x1 << 2
SQU = 0x1 << 1
SIN = 0x1
SAW = 0x0





def init_scan(datapath):
# Example of scan process - "Common Rendering"
    boundary = 1024
    frame_rate = 25
    V_res = 576
    H_res = 720
    # Set Xout
    waveform=datapath.changeWaveform(SAW)
    freq_set=datapath.setFrequency(frame_rate * V_res / 1000) # kHz
    harmonic=datapath.setScale(0,0)
    scale=datapath.setScale(1,H_res / boundary)
    offset=datapath.setPhaseOffset(0,0)
    pha=datapath.setPhaseOffset(1,0)
    func_sel=datapath.selectFuncGen(0)
    func_sel=datapath.deselectFuncGen()

    router=datapath.Wiring_Modifier_Param(0, 0, 0)
    router=datapath.paramConf(0, 0, 1)

    # Set Yout
    waveform=datapath.changeWaveform(SAW)
    freq_set=datapath.setFrequency(frame_rate) # Hz
    harmonic=datapath.setScale(0,0)
    scale=datapath.setScale(1,V_res / boundary)
    offset=datapath.setPhaseOffset(0,0)
    pha=datapath.setPhaseOffset(1,0)
    func_sel=datapath.selectFuncGen(2)
    func_sel=datapath.deselectFuncGen()

    router=datapath.Wiring_Modifier_Param(1, 0, 2)
    router=datapath.paramConf(1, 0, 1)

    datapath.arstPhase() # Phase resync

frame_rate = 25

dispatcher = Dispatcher()
dispatcher.map("/filter", filter_handler)


def readframes():
    """Example main loop that only runs for 10 iterations before finishing"""
    i=0
    while True:
        frame = hdmi_in.readframe()
        datapath.buffAddrBiasSet(frame)
        time.sleep(1/25)


async def init_main():
    #server = AsyncIOOSCUDPServer((ip, port), dispatcher, asyncio.get_event_loop())
    #transport, protocol = await server.create_serve_endpoint()  # Create datagram endpoint and start serving
    await readframes()  # Enter main loop of program

    transport.close()  # Clean up serve endpoint

print("pre-init")

ol = pynq.Overlay('/home/xilinx/pynq/overlays/datapath/base.bit')
datapath = ol.Datapath_DMA_0
init_scan(datapath)
hdmi_in = ol.video.hdmi_in
hdmi_in.configure(PIXEL_RGB)
hdmi_in.start()

print("inited")

try:
    start_osc_thread(datapath)
    raise Exception("Test")
    readframes()
except e:
    hdmi_in.close()
    raise e

