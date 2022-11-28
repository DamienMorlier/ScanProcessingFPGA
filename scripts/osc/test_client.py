from pythonosc.udp_client import SimpleUDPClient

client = SimpleUDPClient("127.0.0.1", 5005)
client.send_message("/example_with_args", [50, 100])
client.send_message("/example_no_args", 100)
