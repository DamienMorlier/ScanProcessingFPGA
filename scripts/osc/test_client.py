from pythonosc.udp_client import SimpleUDPClient
import random

params = ["sync", "harmonic", "frequency", "scale", "phase", "offset", "waveform", "blanking_width", "blanking_phase"]

client = SimpleUDPClient("127.0.0.1", 5005)

print("triggering address : /generator/15/frequency")
client.send_message("/generator/15/frequency", [50])
print("triggering address : /generator/22/scale")
client.send_message("/generator/22/scale", [50])
print("triggering address : /wiring/8/modifier")
client.send_message("/wiring/8/modifier", [[50, 100]])
print("triggering address : /wiring/2/connection")
client.send_message("/wiring/2/connection", [[50, 100, 1]])

