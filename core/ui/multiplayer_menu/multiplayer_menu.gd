extends MarginContainer

var main_scene: PackedScene = preload("uid://cpcymwvh3h4ny")

@onready var main_menu_scene: PackedScene = load("uid://cv72gepsh2eqd")

@onready var username_text_edit: TextEdit = %UsernameTextEdit
@onready var port_text_edit: TextEdit = %PortTextEdit
@onready var ip_address_text_edit: TextEdit = %IPAddressTextEdit
@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton
@onready var back_button: Button = %BackButton
@onready var error_container: MarginContainer = $ErrorContainer
@onready var client_error_label: Label = %ClientErrorLabel
@onready var server_error_label: Label = %ServerErrorLabel
@onready var error_acknowledge_button: Button = %ErrorAcknowledgeButton

var is_connecting: bool


func _ready() -> void:
	error_container.visible = false
	error_acknowledge_button.pressed.connect(
		_on_error_acknowledge_button_pressed
	)
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	# Hook into text change events
	username_text_edit.text_changed.connect(_on_text_changed)
	port_text_edit.text_changed.connect(_on_text_changed)
	ip_address_text_edit.text_changed.connect(_on_text_changed)

	username_text_edit.text = MultiplayerConfig.username
	port_text_edit.text = str(MultiplayerConfig.port)
	ip_address_text_edit.text = MultiplayerConfig.ip_address

	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

	validate()
	
	UIAudioManager.register_buttons([
		back_button, host_button, join_button, error_acknowledge_button
	])


# Validate that port is int, username is not empty, and verify that IP is valid
func validate():
	var port_input := port_text_edit.text
	var ip_address_input := ip_address_text_edit.text

	if port_input.is_valid_int():
		MultiplayerConfig.port = int(port_input)
		if MultiplayerConfig.port <= 0:
			MultiplayerConfig.port = -1
	else:
		MultiplayerConfig.port = -1

	if ip_address_input.is_valid_ip_address():
		MultiplayerConfig.ip_address = ip_address_input
	else:
		MultiplayerConfig.ip_address = ""

	MultiplayerConfig.username = username_text_edit.text

	var is_valid_port: bool = MultiplayerConfig.port > 0
	var is_valid_username: bool = not MultiplayerConfig.username.is_empty()
	var is_valid_ip_address: bool = not MultiplayerConfig.ip_address.is_empty()

	host_button.disabled = (
		is_connecting or not is_valid_port or not is_valid_username
	)
	join_button.disabled = (
		is_connecting
		or not is_valid_port
		or not is_valid_username
		or not is_valid_ip_address
	)


func show_error(is_client_error: bool):
	client_error_label.visible = is_client_error
	server_error_label.visible = not is_client_error

	error_container.visible = true


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_host_button_pressed() -> void:
	var server_peer := ENetMultiplayerPeer.new()
	var error := server_peer.create_server(MultiplayerConfig.port)

	# Global "Error" enum
	if error != Error.OK:
		show_error(false)
		return

	multiplayer.multiplayer_peer = server_peer
	get_tree().change_scene_to_packed(main_scene)


func _on_join_button_pressed() -> void:
	var client_peer := ENetMultiplayerPeer.new()
	var error := client_peer.create_client(
		MultiplayerConfig.ip_address, MultiplayerConfig.port
	)

	if error != Error.OK:
		show_error(true)
		return

	is_connecting = true
	multiplayer.multiplayer_peer = client_peer
	validate()


func _on_error_acknowledge_button_pressed():
	error_container.visible = false


func _on_connected_to_server():
	get_tree().change_scene_to_packed(main_scene)


func _on_connection_failed():
	is_connecting = false
	validate()
	show_error(true)


func _on_text_changed():
	validate()
