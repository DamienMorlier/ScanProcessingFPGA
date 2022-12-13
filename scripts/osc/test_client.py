from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("192.168.2.99", 5005)
client.send_message("/zoom", [[50, 100]])
# client.send_message("/rX", [100, 12])
