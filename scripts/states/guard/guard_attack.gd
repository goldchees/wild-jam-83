extends GuardState
@export var Bullet : PackedScene
@onready var bullet_timer: Timer = %BulletTimer
@onready var bullet_marker: Marker2D = $"../../BulletMarker"

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(_delta: float) -> void:
	if guard.target != null:
		guard.look_at(guard.target.position)

func enter_state(previous_state : String, data := {}) -> void:
	bullet_timer.start(0.0)

func _on_bullet_timer_timeout() -> void:
	if guard.target != null:
		var bullet_scene = Bullet.instantiate()
		get_tree().root.add_child(bullet_scene)
		bullet_scene.global_transform = bullet_marker.global_transform
		bullet_timer.wait_time = randf_range(0.2, 0.5)
		bullet_timer.start()
