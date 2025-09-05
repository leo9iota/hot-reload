extends Control

@onready var host_button: Button = $HBoxContainer/HostButton
@onready var play_button: Button = $HBoxContainer/PlayButton


func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	play_button.pressed.connect(_on_play_pressed)


func _on_host_pressed() -> void:
	print("Host button pressed")


func _on_play_pressed() -> void:
	print("Play button pressed")
