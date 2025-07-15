class_name Guard
extends Actor

@onready var raycast_holder: Node2D = $RaycastHolder

var target : Player = null

func _init() -> void:
	speed = 200

func _process(delta: float) -> void:
	super(delta)
	raycast_detection()

func raycast_detection() -> void:
	for raycast : RayCast2D in raycast_holder.get_children():
		if raycast.is_colliding() and raycast.get_collider() is Player:
			target = raycast.get_collider()
