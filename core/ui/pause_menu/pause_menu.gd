extends CanvasLayer

var current_paused_peer: int = -1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			request_unpause.rpc_id(MultiplayerPeer.TARGET_PEER_SERVER)
		else:
			request_pause.rpc_id(MultiplayerPeer.TARGET_PEER_SERVER)
		get_viewport().set_input_as_handled()


@rpc("any_peer", "call_local", "reliable")
func request_pause():
	if current_paused_peer > -1:
		return

	current_paused_peer = multiplayer.get_remote_sender_id()
	pause.rpc()


@rpc("any_peer", "call_local", "reliable")
func request_unpause():
	if current_paused_peer != multiplayer.get_remote_sender_id():
		return

	current_paused_peer = -1
	unpause.rpc()


@rpc("any_peer", "call_local", "reliable")
func pause():
	get_tree().paused = true
	visible = true


@rpc("any_peer", "call_local", "reliable")
func unpause():
	get_tree().paused = false
	visible = false
