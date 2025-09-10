class_name Bullet extends Node2D

const SPEED: int = 600

@onready var life_timer: Timer = $LifeTimer
@onready var hitbox_component: HitboxComponent = $HitboxComponent

var direction: Vector2


func _ready() -> void:
	hitbox_component.hit_hurtbox.connect(_on_hit_hurtbox)
	life_timer.timeout.connect(_on_life_timer_timeout)


func _process(delta: float) -> void:
	global_position += direction * SPEED * delta


func start(initial_direction: Vector2):
	direction = initial_direction
	rotation = initial_direction.angle()


func register_collision():
	queue_free()


func _on_life_timer_timeout():
	if is_multiplayer_authority():
		queue_free()


# We don't use the '_hurtbox_component', but we do need to accept it,
# because the signal handler's signature need to match the argument list
# that is emitted with the signal.
func _on_hit_hurtbox(_hurtbox_component: HurtboxComponent):
	register_collision()
