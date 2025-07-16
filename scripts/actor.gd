class_name Actor
extends CharacterBody2D

@export var speed = 400
@onready var energy_bar : ProgressBar = get_node_or_null("entityEnergyBar")
@onready var energy : float = max_energy
var max_energy : float = 100.0
var died := false

var is_possessed : bool = false

var aim: Vector2 = Vector2.UP

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
	died = true
	print(name + " tragically died")


func move(input_vector: Vector2):
	velocity = input_vector * speed
	move_and_slide()
	pass
	
func update_energy_bar():
	if (energy_bar):
		energy_bar.value = energy

func _draw():
	# if (!is_possessed):
		draw_line(Vector2.ZERO,aim * 48,Color.WHITE, 6.0)