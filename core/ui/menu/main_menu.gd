extends Control

const PORT: int = 3000

var main_scene: PackedScene = preload("uid://cpcymwvh3h4ny")

@onready var singleplayer_button: Button = $VBoxContainer/SingleplayerButton
@onready var multiplayer_button: Button = $VBoxContainer/MultiplayerButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	singleplayer_button.pressed.connect(_on_singleplayer_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)


#func _on_host_pressed() -> void:
	#var server_peer := ENetMultiplayerPeer.new()
	#server_peer.create_server(PORT)
	#multiplayer.multiplayer_peer = server_peer
	#get_tree().change_scene_to_packed(main_scene)
#
#
#func _on_join_pressed() -> void:
	#var client_peer := ENetMultiplayerPeer.new()
	#client_peer.create_client("127.0.0.1", PORT)
	#multiplayer.multiplayer_peer = client_peer


func _on_connected_to_server():
	get_tree().change_scene_to_packed(main_scene)


func _on_singleplayer_button_pressed():
	get_tree().change_scene_to_packed(main_scene)

	
	
func _on_multiplayer_button_pressed():
	pass
	
func _on_quit_button_pressed():
	get_tree().quit()
