extends Control

var main_scene: PackedScene = preload("uid://cpcymwvh3h4ny")

@onready var singleplayer_button: Button = %SingleplayerButton
@onready var multiplayer_button: Button = %MultiplayerButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	singleplayer_button.pressed.connect(_on_singleplayer_button_pressed)
	multiplayer_button.pressed.connect(_on_multiplayer_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_singleplayer_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_multiplayer_button_pressed():
	pass


func _on_quit_button_pressed():
	get_tree().quit()
