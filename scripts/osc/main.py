from typing import List, Any
from osc_handler import OSCHandler

"""
Here is a good guide on how OSC messages work:

http://www.music.mcgill.ca/~gary/306/week9/osc.html
"""


# def example_no_args(osc_handler: OSCHandler):
#     def my_example_callback(addr: str, data: List[Any]):
#         print(f"{addr} : {data}")
    
#     osc_handler.subscribe("/example_no_args", my_example_callback)

# def example_with_args(osc_handler: OSCHandler):
#     def my_example_callback(addr: str, args: List[Any], data: List[Any]):
#         print(f"{addr} : {args} ; {data}")
    
#     osc_handler.subscribe("/example_with_args", my_example_callback)

"""Some high level transform function"""
addresses = ["/zoom", "/ampH", "/freqH", "/ampV", "/freqV", "/rX", "/rY", "/rZ", "/offsetX", "/offsetY"]

def set_zoom(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    zoom = data[0]
    #TODO : send it to FPGA

def set_ampH(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    amp = data[0]
    #TODO : send it to FPGA
    
def set_freqH(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    freq = data[0]
    #TODO : send it to FPGA

def set_ampV(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    amp = data[0]
    #TODO : send it to FPGA

def set_freqV(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    freq = data[0]
    #TODO : send it to FPGA

def set_rX(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    rot = data[0]
    #TODO : send it to FPGA

def set_rY(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    rot = data[0]
    #TODO : send it to FPGA

def set_rZ(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    rot = data[0]
    #TODO : send it to FPGA

def set_offsetX(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    offset = data[0]
    #TODO : send it to FPGA

def set_offsetY(addr: str, data: List[Any]):
    print(f"{addr} : {data}")
    offset = data[0]
    #TODO : send it to FPGA

functions = [set_zoom, set_ampH, set_freqH, set_ampV, set_freqV, set_rX, set_rY, set_rZ, set_offsetX, set_offsetY]

"""To customise each func gen, no mapping done yet for those adresses"""
params = ["/sync", "/switch", "/frequency", "/scale1", "/scale2", "/phaseoff1", "/phaseoff2", "/waveform"]

def Sync(addr: str, funcGen: int, data: List[Any]):
    return

def Switch(addr: str, funcGen: int, data: List[Any]):
    return

def Frequency(addr: str, funcGen: int, data: List[Any]):
    return

def Scale1(addr: str, funcGen: int, data: List[Any]):
    return

def Scale2(addr: str, funcGen: int, data: List[Any]):
    return

def PhaseOff1(addr: str, funcGen: int, data: List[Any]):
    return

def PhaseOff2(addr: str, funcGen: int, data: List[Any]):
    return

def Waveform(addr: str, funcGen: int, data: List[Any]):
    return

def main():
    ## Initialize OSC handling
    osc_handler = OSCHandler("0.0.0.0", 5005)
    
    ## Initialize hardware wrappers
    
    # example_no_args(osc_handler)
    # example_with_args(osc_handler)

    for i in range(len(addresses)):
        osc_handler.subscribe(addresses[i], functions[i])
    
    ## Serve 
    osc_handler.serve()
    

if __name__ == "__main__":
    main()