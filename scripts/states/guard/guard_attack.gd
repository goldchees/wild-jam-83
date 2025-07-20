extends GuardState
@export var Bullet : PackedScene
@onready var bullet_timer: Timer = %BulletTimer
@onready var bullet_marker: Marker2D = $"../../BulletMarker"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(_delta: float) -> void:
	if guard.died or guard.is_possessed: return
	if guard.target != null:
		guard.aim_at(guard.target.position)
		sprite_2d.rotation = guard.aim.angle() + PI/2

func enter_state(previous_state : String, data := {}) -> void:
	bullet_timer.start(0.0)

func _on_bullet_timer_timeout() -> void:
	#print("died: " + str(guard.died))
	#print("is_possessed: " + str(guard.is_possessed))
	if guard.target != null and !guard.died and !guard.is_possessed:
		print('shoot')
		var bullet_scene: Bullet = Bullet.instantiate()
		get_tree().root.add_child(bullet_scene)
		bullet_scene.global_transform = guard.raycast_holder.global_transform
		bullet_scene.global_position = guard.global_position + guard.aim * 48
		bullet_timer.wait_time = randf_range(0.2, 0.5)
		bullet_timer.start()
