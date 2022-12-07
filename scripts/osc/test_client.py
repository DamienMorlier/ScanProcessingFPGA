from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("127.0.0.1", 5005)
client.send_message("/zoom", [[50, 100]])
# client.send_message("/rX", [100, 12])
