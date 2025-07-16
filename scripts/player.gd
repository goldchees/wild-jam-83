class_name Player
extends Actor

@export var host: Actor

var move_actions: Array[String] = ["move_left","move_right","move_up","move_down"]
var aim_actions: Array[String] = ["aim_left","aim_right","aim_up","aim_down"]
var reach_action = "action_1"
var action2 = "action_2"

var aim := Vector2.UP
var reach = 200

var tentacle_tip: Vector2
var tentacle_speed = 600
var tentacle_reach = 200

var reaching = false
var potential_host: Actor = null
var wiggle = 0

var is_possessing = false

func _ready():
	energy_bar = %energyBar

func _process(delta: float) -> void:
	super(delta)
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


	var input_vector = Input.get_vector(move_actions[0],move_actions[1],move_actions[2],move_actions[3])
	if (input_vector.length_squared() > 0):
		# aim = input_vector.normalized()
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

	if (Input.is_action_just_pressed(action2)):
		if (host != null && host != self):
			leave_host()
		else:
			$dash_ability.on_dash_action()
	
	if (energy_bar.value > 0):
		if (is_possessing):
			energy += delta * 10
			host.energy -= delta * 10
		else:
			energy -= delta * 5
	
	energy_bar.value = energy
	
	queue_redraw()

func _input(event: InputEvent) -> void:
	var aim_input_vector = Input.get_vector(aim_actions[0],aim_actions[1],aim_actions[2],aim_actions[3])
	if aim_input_vector.length() > 0.1:
		aim = aim_input_vector.normalized()
	if event is InputEventMouseMotion && !event.relative.is_zero_approx():
		aim = global_position.direction_to(get_global_mouse_position())

func leave_host():
	if (host == self): return
	get_parent().remove_child(self)
	host.get_parent().add_child(self)
	position = host.position + aim
	$CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	host.is_possessed = false
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
	if (host == self):
		host.is_possessed = false
	else:
		host.is_possessed = true

func _draw():
	var color = Color.LIME_GREEN

	draw_line(Vector2.ZERO,aim * 48,Color.WHITE, 6.0)
	draw_circle(Vector2.ZERO,48,color,false)

	if (reaching):
		var resolution = 20 
		var perpendicular = tentacle_tip.rotated(PI / 2).normalized()
		var length = tentacle_tip.length()

		var points = []
		for i in resolution:
			var easing: float = min(i,4) / 4
			var offset1: Vector2 = perpendicular * sin(i + wiggle) * min((resolution - i)*(resolution - i) * 0.05 + 1,24) * easing
			points.push_back(tentacle_tip.normalized() * i * length / resolution + offset1)
		draw_polyline(points,color,4)
	
	if (!is_possessing):
		var pulse_radius = 36 + sin(wiggle) * 0.75
		draw_circle(Vector2.ZERO, pulse_radius, color, true)
		var wiggle_resolution = 18
		var radius = 32.0
		var wiggle_length = 11.0
		for i in wiggle_resolution:
			var angle = i * TAU / wiggle_resolution
			var dir = Vector2.RIGHT.rotated(angle)
			var base_pos = dir * radius
			var wiggle_offset = sin(wiggle + i) * 5.0
			var end_pos = base_pos + dir * wiggle_length + dir.rotated(PI / 2) * wiggle_offset
			draw_line(base_pos, end_pos, color, 3.5)
