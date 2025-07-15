class_name Guard
extends Actor

@onready var entity_energy_bar: ProgressBar = $entityEnergyBar
@onready var raycast_holder: Node2D = $RaycastHolder

var died = false 

var target : Player = null

func _init() -> void:
	speed = 200

func _process(delta: float) -> void:
	if entity_energy_bar.value <= 0 && !died:
		died = true
		print(name + "died")
	
	raycast_detection()
	
	

func lose_energy():
	entity_energy_bar.value -= 0.1


func raycast_detection() -> void:
	for raycast : RayCast2D in raycast_holder.get_children():
		if raycast.is_colliding() and raycast.get_collider() is Player:
			target = raycast.get_collider()
