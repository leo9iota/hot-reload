class_name WeaponResource extends Resource

enum FireMode { SEMI, AUTO, BURST }

@export_group("Identity")
@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
@export var muzzle_offset: Vector2 = Vector2(16, 0)

@export_group("Fire")
@export var fire_mode: FireMode = FireMode.SEMI
@export var damage: float = 10.0
@export var fire_rate: float = 5.0   # shots per second
@export var burst_count: int = 3
@export var spread_degrees: float = 0.0
@export var hitscan: bool = false

@export_group("Bullet")
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 1200.0
@export var bullet_range: float = 1000.0

@export_group("Magazine Size")
@export var magazine_size: int = 30
@export var reload_time: float = 1.8

@export_group("Effects")
@export var muzzle_vfx: PackedScene
@export var sfx_shoot: AudioStream
@export var sfx_reload: AudioStream
