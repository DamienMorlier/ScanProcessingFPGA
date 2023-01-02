from pythonosc.udp_client import SimpleUDPClient
import random

params = ["/sync", "/harmonic", "/frequency", "/scale", "/phase", "/offset", "/waveform"]

client = SimpleUDPClient("127.0.0.1", 5005)

client.send_message("/matrix/F/0", [[50, 100]])
client.send_message("/generator/229/sync", [[50, 100]])
client.send_message("/generator/29/blanking_width", [[50, 100]])

