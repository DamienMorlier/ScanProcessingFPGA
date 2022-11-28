from typing import List, Any
from osc_handler import OSCHandler

"""
Here is a good guide on how OSC messages work:

http://www.music.mcgill.ca/~gary/306/week9/osc.html
"""

def example_sub(osc_handler: OSCHandler):
    def my_example_callback(addr: str, args: List[Any], data: List[Any]):
        print(f"{addr} : {args} ; {data}")
    
    osc_handler.subscribe("/example", my_example_callback)

def main():
    ## Initialize OSC handling
    osc_handler = OSCHandler("0.0.0.0", 5005)
    
    ## Initialize hardware wrappers
    example_sub(osc_handler)
    
    ## Serve 
    osc_handler.serve()
    

if __name__ == "__main__":
    main()