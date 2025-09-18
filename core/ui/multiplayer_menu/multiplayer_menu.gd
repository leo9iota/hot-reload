extends MarginContainer

const PORT: int = 3000

var main_scene: PackedScene = preload("uid://cpcymwvh3h4ny")

@onready var main_menu_scene: PackedScene = load("uid://cv72gepsh2eqd")

@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_host_button_pressed() -> void:
	var server_peer := ENetMultiplayerPeer.new()
	server_peer.create_server(PORT)
	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene)


func _on_join_button_pressed() -> void:
	var client_peer := ENetMultiplayerPeer.new()
	client_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = client_peer


func _on_connected_to_server():
	get_tree().change_scene_to_packed(main_scene)
