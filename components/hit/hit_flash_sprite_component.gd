extends Sprite2D

@export var health_component: HealthComponent

var shader_tween: Tween
var _material_unique := false


func _ready() -> void:
	# Ensure this Sprite2D has its own unique material on ALL peers so shader
	# parameter changes don't propagate to all instances that share the resource.
	_ensure_unique_material()

	# Only the authority should react to damage events and propagate the visual
	# to everyone else via RPC. In single-player, authority is true as well.
	if is_multiplayer_authority() and health_component:
		health_component.damaged.connect(_on_damaged)


@rpc("authority", "call_local", "unreliable")
func _play_hit_flash():
	_ensure_unique_material()

	# Logic to prevent multiple tweens at the same time, if tween isn't finished yet
	if shader_tween != null and shader_tween.is_valid():
		shader_tween.kill()

	shader_tween = create_tween()
	(
		shader_tween
		. tween_property(material, "shader_parameter/percent", 0.0, 0.2)
		. from(1.0)
		. set_trans(Tween.TRANS_QUINT)
		. set_ease(Tween.EASE_IN)
	)

func _on_damaged():
	_play_hit_flash.rpc()


func _ensure_unique_material() -> void:
	if _material_unique:
		return
	if material == null:
		return

	material = material.duplicate()
	material.resource_local_to_scene = true
	_material_unique = true
