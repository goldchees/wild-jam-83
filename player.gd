class_name Player
extends Actor

@export var host: Actor

var wasd: Array[String] = ["move_left","move_right","move_up","move_down"]
var reach_action = "action_1"

var aim: Vector2
var reach = 200

var tentacle_tip: Vector2
var tentacle_speed = 600
var tentacle_reach = 200

var reaching = false
var potential_host: Actor = null
var wiggle = 0

var is_possessing = false

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed(reach_action)):
		reaching = true
		tentacle_tip = Vector2.ZERO
		wiggle = 0

	if (reaching):
		wiggle += delta
		var q = PhysicsPointQueryParameters2D.new()
		q.position = global_position + tentacle_tip
		var results = get_world_2d().direct_space_state.intersect_point(q)
		for r in results:
			if (r.collider is Actor):
				if (r.collider != host):
					potential_host = r.collider
			pass
	
	if (Input.is_action_just_released(reach_action)):
		if (potential_host != null):
			possess(potential_host)
		reaching = false
		potential_host = null
		


	var input_vector = Input.get_vector(wasd[0],wasd[1],wasd[2],wasd[3])
	if (input_vector.length_squared() > 0):
		aim = input_vector.normalized()
		wiggle += delta * 4
		
	if (reaching):
		if (potential_host):
			tentacle_tip = potential_host.global_position - global_position
			pass
		else:
			var tspeed = tentacle_speed
			if (tentacle_tip.length() > tentacle_reach):
				tspeed = 300 
			tentacle_tip += input_vector * delta * tspeed
			if (tentacle_tip.length() > tentacle_reach):
				tentacle_tip = tentacle_tip.move_toward(Vector2.ZERO,200 * delta)
				pass
	elif(host != null):
		host.move(input_vector)
	else: self.move(input_vector)
	
	if (Input.is_action_just_pressed("action_2")):
		if (host != null):
			leave_host()
	
	if (is_possessing and $"../../energyBar".value > 0):
		$"../../energyBar".value += 0.1
		get_parent().lose_energy()
	else:
		$"../energyBar".value -= 0.1
	
	queue_redraw()

func leave_host():
	if (host == self): return
	get_parent().remove_child(self)
	host.get_parent().add_child(self)
	position = host.position + aim
	$CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	host = self
	is_possessing = false

func possess(target: Actor):
	if (host == self):
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	position = Vector2.ZERO
	host = target
	get_parent().remove_child(self)
	host.add_child(self)
	queue_redraw()
	is_possessing = true

func _draw():
	draw_line(Vector2.ZERO,aim * 48,Color.WHITE)
	draw_circle(Vector2.ZERO,48,Color.GREEN,false)

	if (reaching):
		var thickness = 4
		if (potential_host): thickness = 8
		# draw_line(Vector2.ZERO,tentacle_tip,Color.GREEN,thickness)

		var resolution = 20 
		var perpendicular = tentacle_tip.rotated(PI / 2).normalized()
		var length = tentacle_tip.length()

		var points = []
		for i in resolution:
			var easing: float = min(i,4) / 4
			var offset1: Vector2 = perpendicular * sin(i + wiggle) * min((resolution - i)*(resolution - i) * 0.05 + 1,24) * easing
			points.push_back(tentacle_tip.normalized() * i * length / resolution + offset1)
		draw_polyline(points,Color.GREEN,4)
