class_name LobbyManager extends Node

signal all_peers_ready

var ready_peer_ids: Array[int] = []
var is_lobby_closed: bool = false


func _ready() -> void:
	if is_multiplayer_authority():
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		
	# Bypass "Ready Up" functionality if we're in single-player mode.
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		# Call deferred to ensure that the "_ready" method in main.gd emits
		# first before we emit this signal.
		all_peers_ready.emit.call_deferred()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lobby_ready"):
		request_peer_ready.rpc_id(MultiplayerPeer.TARGET_PEER_SERVER)
		get_viewport().set_input_as_handled()


func close_lobby():
	is_lobby_closed = true


@rpc("any_peer", "call_local", "reliable")
func request_peer_ready():
	if not is_multiplayer_authority() or is_lobby_closed:
		return

	var sender_id := multiplayer.get_remote_sender_id()

	if not ready_peer_ids.has(sender_id):
		ready_peer_ids.append(sender_id)

	try_all_peers_ready()


func try_all_peers_ready():
	if check_all_peers_ready():
		all_peers_ready.emit()


func check_all_peers_ready() -> bool:
	var all_peers := multiplayer.get_peers()
	all_peers.append(MultiplayerPeer.TARGET_PEER_SERVER)

	for peer_id in all_peers:
		if not ready_peer_ids.has(peer_id):
			return false

	return true
	
	
func _on_peer_disconnected(_peer_id: int):
	try_all_peers_ready()
