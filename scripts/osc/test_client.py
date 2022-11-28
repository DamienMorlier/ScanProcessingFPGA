from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("127.0.0.1", 5005)
client.send_message("/example", [50, 100])
