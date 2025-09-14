class_name HealthComponent extends Node

signal died
signal damaged

# In the 'health_component' and 'player_input_synchronizer_component',
# we use the composition pattern
@export var max_health: int = 1

var current_health: int = 0


func _ready() -> void:
	current_health = max_health


func damage(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	damaged.emit()

	if current_health == 0:
		died.emit()
