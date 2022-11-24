from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("127.0.0.1", 1337)
client.send_message("/func_gen/0/reset", 100)
