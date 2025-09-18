extends Control

var main_scene: PackedScene = preload("uid://cpcymwvh3h4ny")

@onready var multiplayer_menu_scene: PackedScene = load("uid://bpidy5vmv2up")

@onready var singleplayer_button: Button = %SingleplayerButton
@onready var multiplayer_button: Button = %MultiplayerButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	singleplayer_button.pressed.connect(_on_singleplayer_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	UIAudioManager.register_buttons(
		[singleplayer_button, multiplayer_button, quit_button]
	)


func _on_singleplayer_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_multiplayer_button_pressed():
	get_tree().change_scene_to_packed(multiplayer_menu_scene)


func _on_quit_button_pressed():
	get_tree().quit()
