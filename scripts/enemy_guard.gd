class_name Guard
extends Actor
@export var pathway: PathFollow2D
@onready var raycast_holder: Node2D = $RaycastHolder

var current_position : Vector2
var target : Actor = null

func _init() -> void:
	speed = 200

func _process(delta: float) -> void:
	super(delta)
	if self.is_possessed || self.died:
		return
	
	raycast_holder.look_at(global_position + aim)
	raycast_detection()

func raycast_detection() -> void:
	for raycast : RayCast2D in raycast_holder.get_children():
		if raycast.is_colliding() and raycast.get_collider() is Actor:
			var current_actor : Actor = raycast.get_collider()
			if current_actor.is_possessed or current_actor is Player:
				target = raycast.get_collider()
			else:
				continue
		else:
			continue

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Actor:
		var current_actor: Actor = body
		if current_actor is Player:
			target = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Actor:
		var current_actor: Actor = body
		if current_actor is Player:
			target = null
