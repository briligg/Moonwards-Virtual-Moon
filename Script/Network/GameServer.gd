extends ANetworkInstance
class_name GameServer

var port: int = 0
var max_players: int = 0
var is_host_player: bool = false

var server_peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()

func _init(_port: int, _max_players: int, _is_host_player: bool = false):
	self.port = _port
	self.max_players = _max_players
	self.is_host_player = _is_host_player
	self.name = "GameServer"

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_host_game()

func _host_game() -> void:
	var err = server_peer.create_server(port, max_players)
	if err == OK:
		get_tree().set_network_peer(server_peer)
		_start_game()
	elif err == ERR_CANT_CREATE:
		Log.critical(self, "", "Could not create server peer.")
	elif err == ERR_ALREADY_EXISTS:
		Log.error(self, "", "Server peer already exists.")

func _start_game() -> void:
	Log.trace(self, "", "Server instance started.")
	# Add lobby host player
	if self.is_host_player:
		var player = PlayerData.new(1, "Server", _get_spawn())
		players[1] = player
		add_player(player.serialize())

### Temporary
func _get_spawn() -> Vector3:
	return Vector3(rand_range(4.2, 4.5), .5, rand_range(1.8, 2))

func _player_connected(peer_id) -> void:
	var player_data = PlayerData.new(peer_id, str(peer_id), _get_spawn())
	players[player_data.peer_id] = player_data
	# Send existing players to newly conencted peer for loading
	var data = []
	for player in players.values():
		data.append(player.serialize())
	var data2 = []
	for p in data:
		data2.append(PlayerData.new().deserialize(p))
	rpc_id(peer_id, "initial_client_load_entities", data)
	# Need to dispose of the yield if the player fails to load.
	# Wait until we receive a signal that the player has loaded.
	while yield(Signals.Network, Signals.Network.CLIENT_LOAD_FINISHED) != player_data.peer_id:
		pass
	# Resume spawning the player.
	crpc(self, "add_player", player_data.serialize(),[peer_id])
	Log.trace(self, "", "CONNECTED: %s" %peer_id)

func _player_disconnected(peer_id) -> void:
	crpc(self, "remove_player", peer_id)
	Log.trace(self, "", "DISCONNECTED: %s" %peer_id)
