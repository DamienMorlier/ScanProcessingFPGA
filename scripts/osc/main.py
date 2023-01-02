from typing import List, Any
from osc_handler import OSCHandler


FUNC_NUMBER = 24

"""
Here is a good guide on how OSC messages work:

http://www.music.mcgill.ca/~gary/306/week9/osc.html
"""

params = ["sync", "harmonic", "frequency", "scale", "phase", "offset", "waveform", "blanking_width", "blanking_phase"]

def main():
    ## Initialize OSC handling
    osc_handler = OSCHandler("0.0.0.0", 5005)
    
    paramsHandler = [osc_handler.Sync, osc_handler.Harmonic, osc_handler.Frequency, osc_handler.Scale, osc_handler.Phase, osc_handler.Offset, osc_handler.Waveform, osc_handler.Blanking_Width, osc_handler.Blanking_Phase]
    
    ## Initialize hardware wrappers
    for i in range(len(params)):
        osc_handler.subscribe(f"/generator/*/{params[i]}", paramsHandler[i])
    osc_handler.subscribe("/matrix/*", osc_handler.Matrix)
    
    ## Serve 
    osc_handler.serve()
    

if __name__ == "__main__":
    main()