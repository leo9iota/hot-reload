class_name Player extends CharacterBody2D

@onready var player_input_synchronizer_component: PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var weapon_root: Node2D = $WeaponRoot

var bullet_scene: PackedScene = preload("uid://clscgesvupype")

var input_multiplayer_authority: int


func _ready():
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)


func _process(delta: float) -> void:
	var aim_position = weapon_root.global_position + player_input_synchronizer_component.aim_vector
	weapon_root.look_at(aim_position)

	if is_multiplayer_authority():
		velocity = player_input_synchronizer_component.movement_vector * 100
		move_and_slide()
		if player_input_synchronizer_component.is_attack_pressed:
			create_bullet()


func create_bullet():
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = weapon_root.global_position
	get_parent().add_child(bullet, true)
	bullet.start(player_input_synchronizer_component.aim_vector)
