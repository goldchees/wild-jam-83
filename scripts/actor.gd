class_name Actor
extends CharacterBody2D

@export var speed = 250
@onready var energy_bar : ProgressBar = get_node_or_null("entityEnergyBar")
@onready var energy : float = max_energy
var max_energy : float = 100.0
var died := false

var is_possessed : bool = false

var aim: Vector2 = Vector2.UP

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var blood_particles: GPUParticles2D = $bloodParticles

func _ready() -> void:
	sprite_2d.frame = 0
	died = false

func aim_at(vector: Vector2):
	aim = global_position.direction_to(vector)

func _process(delta):
	if energy > max_energy:
		energy = max_energy
	if energy <= 0 && !died:
		die()
	update_energy_bar()
	queue_redraw()

func lose_energy():
	energy -= 0.1

func die():
	sprite_2d.frame = 1
	died = true
	var parasite = get_child(get_child_count() - 1)
	if blood_particles:
		blood_particles.emitting = true
		get_tree().create_timer(1.1).timeout.connect(_on_blood_timer_timeout)
	if parasite.has_method("leave_host"): 
		parasite.leave_host()
	print(name + " tragically died")
	set_process(false)
	set_physics_process(false)

func move(input_vector: Vector2):
	velocity = input_vector * speed
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, input_vector.angle() + PI / 2, 0.2)
	move_and_slide()
	pass
	
func update_energy_bar():
	if (energy_bar):
		energy_bar.value = energy

func _draw():
	# if (!is_possessed):
		draw_line(Vector2.ZERO,aim * 48,Color.WHITE, 6.0)

func _on_blood_timer_timeout() -> void:
	blood_particles.speed_scale = 0
