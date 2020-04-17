extends Node
"""
	Boot Scene Script
	Initializes headless server if required
"""

func _ready() -> void:
#	if OS.has_feature("Server"):
#		_ready_headless()
#	else:
	var test_scene = preload("res://_tests/NewDemo/TestScene.tscn")
	get_tree().change_scene_to(test_scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# func _ready_headless() -> void:
# 	Log.hint(self, "_ready_headless", "Initializing Headless Server")
# 	print("Starting server 1/4: Trying to load the world")
	
# 	var player_data : Dictionary = {
# 		name = "Server bot",
# 		options = Options.player_data_set_pattern("server_bot")
# 	}
# 	Lobby.connect_to_server(player_data, true)
