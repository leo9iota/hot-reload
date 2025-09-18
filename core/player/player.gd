class_name Player extends CharacterBody2D
signal died

@onready
var player_input_synchronizer_component: PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var weapon_root: Node2D = $Visuals/WeaponRoot
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals
@onready var recoil_animation: AnimationPlayer = $RecoilAnimation
@onready var barrel_position: Marker2D = %BarrelPosition
@onready var username_label: Label = %UsernameLabel

var bullet_scene: PackedScene = preload("uid://clscgesvupype")
var muzzle_flash_scene: PackedScene = preload("uid://drj72jf88qsqe")
var input_multiplayer_authority: int
var is_dying: bool
var username: String


func _ready():
	player_input_synchronizer_component.set_multiplayer_authority(
		input_multiplayer_authority
	)

	# Hide username in single-player mode (OfflineMultiplayerPeer)
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		username_label.visible = false
	else:
		username_label.text = username
	
	if is_multiplayer_authority():
		health_component.died.connect(_on_died)


func _process(_delta: float) -> void:
	update_aim_position()
	if is_multiplayer_authority():
		# Fix for error that occurs when player dies during movement
		if is_dying:
			global_position = Vector2.RIGHT * 42069
			return

		velocity = ((player_input_synchronizer_component.movement_vector) * 100)
		move_and_slide()
		if player_input_synchronizer_component.is_attack_pressed:
			try_fire_bullet()


func set_username(username_input: String):
	username = username_input


func update_aim_position():
	var aim_vector = player_input_synchronizer_component.aim_vector
	var aim_position = weapon_root.global_position + aim_vector
	# Flip player in direction of gun
	visuals.scale = (Vector2.ONE if aim_vector.x >= 0 else Vector2(-1, 1))
	weapon_root.look_at(aim_position)


func try_fire_bullet():
	if not fire_rate_timer.is_stopped():
		return

	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = (barrel_position.global_position)
	bullet.start(player_input_synchronizer_component.aim_vector)
	get_parent().add_child(bullet, true)
	fire_rate_timer.start()
	play_fire_effect.rpc()


# Server-side only function
func server_kill_player():
	if not is_multiplayer_authority():
		push_error("Cannot call kill function on non-server client")
		return

	# Sync with all clients
	client_kill_player.rpc()
	await get_tree().create_timer(0.5).timeout

	died.emit()
	queue_free()


@rpc("authority", "call_local", "unreliable")
func play_fire_effect():
	if recoil_animation.is_playing():
		recoil_animation.stop()

	recoil_animation.play("fire")

	var muzzle_flash: Node2D = muzzle_flash_scene.instantiate()
	muzzle_flash.global_position = (barrel_position.global_position)
	muzzle_flash.rotation = (barrel_position.global_rotation)
	get_parent().add_child(muzzle_flash)

	# Only shake camera when player that is firing gun fires gun
	if player_input_synchronizer_component.is_multiplayer_authority():
		GameCamera.shake(1)


@rpc("authority", "call_local", "reliable")
func client_kill_player():
	is_dying = true
	player_input_synchronizer_component.public_visibility = false


func _on_died():
	server_kill_player()
