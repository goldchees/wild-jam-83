class_name Player
extends Actor

@export var host: Actor

enum Tentacle{NONE,REACH,GRAB,ENTER,PULL_SELF}
var tentacle_state: Tentacle = Tentacle.NONE

# stats: (to know when to stop showing input help)
var times_pulled_self := 0
var times_possessed := 0

var move_actions: Array[String] = ["move_left","move_right","move_up","move_down"]
var aim_actions: Array[String] = ["aim_left","aim_right","aim_up","aim_down"]
var reach_action = "action_1"
var action2 = "action_2"

var reach = 200

var tip: Vector2
var tentacle_speed = 600
var tentacle_reach = 200

var reaching: bool:
    get: return tentacle_state == Tentacle.REACH
var potential_host: Actor = null
var wiggle = 0

var in_host: bool:
    get: return host != self && host != null

func _ready():
    energy_bar = %energyBar

func _process(delta: float) -> void:
    super(delta)

    if (tentacle_state == Tentacle.NONE):
        tip = tip.move_toward(Vector2.ZERO,delta * 1000)

    if (tentacle_state == Tentacle.ENTER):
        if (potential_host != null):
            global_position = global_position.move_toward(potential_host.global_position,delta * 800)
            tip = potential_host.global_position - global_position
        if (global_position.is_equal_approx(potential_host.global_position)):
            possess(potential_host)

    if (Input.is_action_just_pressed(action2)):
        if (host != null && host != self):
            leave_host()
        if (tentacle_state == Tentacle.REACH):
            tentacle_state = Tentacle.PULL_SELF
            times_pulled_self += 1
            $CollisionShape2D.disabled = true

    var wander_length = 100
    if (tip.length() < wander_length && wiggle < 2):
        tip = tip.move_toward(aim * wander_length,delta * 200)


    if (tentacle_state == Tentacle.PULL_SELF):
        var global_tip = global_position + tip
        global_position = global_position.move_toward(global_tip,delta * 800)
        tip = global_tip - global_position
        if (global_position.is_equal_approx(global_tip)):
            $CollisionShape2D.disabled = false
            tentacle_state = Tentacle.NONE


    if (tentacle_state == Tentacle.NONE):
        if (Input.is_action_just_pressed(reach_action)):
            tentacle_state = Tentacle.REACH
            tip = Vector2.ZERO
            wiggle = 0

    if (tentacle_state == Tentacle.REACH || tentacle_state == Tentacle.GRAB):

        wiggle += delta
        var q = PhysicsPointQueryParameters2D.new()
        q.position = global_position + tip
        var results = get_world_2d().direct_space_state.intersect_point(q)
        for r in results:
            if (r.collider is Actor):
                if (r.collider != host):
                    potential_host = r.collider

    if (Input.is_action_just_released(reach_action)):
        if (tentacle_state == Tentacle.REACH):
            tentacle_state = Tentacle.NONE
        elif (tentacle_state == Tentacle.GRAB):
            if (potential_host != null):
                try_to_enter_target()
            else:
                tentacle_state = Tentacle.NONE


    var input_vector = Input.get_vector(move_actions[0],move_actions[1],move_actions[2],move_actions[3])
    if (input_vector.length_squared() > 0):
        aim = input_vector.normalized()
        wiggle += delta * 4
        
    if (tentacle_state == Tentacle.REACH):
        if (potential_host):
            tentacle_state = Tentacle.GRAB
            tip = potential_host.global_position - global_position
            pass
        else:
            var tspeed = tentacle_speed
            if (tip.length() > tentacle_reach):
                tspeed = 300 
            tip += input_vector * delta * tspeed
            if (tip.length() > tentacle_reach):
                tip = tip.move_toward(Vector2.ZERO,200 * delta)
                pass
    elif(tentacle_state == Tentacle.GRAB):
        pass

    if (tentacle_state == Tentacle.NONE):
        if(host != null):
            host.move(input_vector)
        else:
            self.move(input_vector)


    if (energy_bar.value > 0):
        if (in_host):
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

func try_to_enter_target():
    if (in_host):
        leave_host()
    $CollisionShape2D.disabled = true
    tentacle_state = Tentacle.ENTER


func leave_host():
    if (host == self): return
    get_parent().remove_child(self)
    host.get_parent().add_child(self)
    position = host.position + aim
    $CollisionShape2D.disabled = false
    $Sprite2D.visible = true
    host.is_possessed = false
    host = self
    tentacle_state = Tentacle.NONE

func possess(target: Actor):
    potential_host = null
    if (host == self):
        $CollisionShape2D.disabled = true
        $Sprite2D.visible = false
    position = Vector2.ZERO
    host = target
    get_parent().remove_child(self)
    host.add_child(self)
    tentacle_state = Tentacle.NONE
    queue_redraw()
    if (host == self):
        host.is_possessed = false
    else:
        host.is_possessed = true
    times_possessed += 1

func _draw():
    var color = Color.LIME_GREEN

    draw_line(Vector2.ZERO,aim * 48,Color.WHITE, 6.0)
    draw_circle(Vector2.ZERO,48,color,false)

    var resolution = 20 
    var perpendicular = tip.rotated(PI / 2).normalized()
    var length = tip.length()

    var points = []
    for i in resolution:
        var easing: float = min(i,4) / 4
        var offset1: Vector2 = perpendicular * sin(i + wiggle) * min((resolution - i)*(resolution - i) * 0.05 + 1,24) * easing
        points.push_back(tip.normalized() * i * length / resolution + offset1)
    draw_polyline(points,color,4)
    
    if (!in_host):
        var radius = 24.0
        if (tentacle_state == Tentacle.ENTER):
            radius = min(radius,global_position.distance_to(potential_host.global_position) / 3)

        var pulse_radius = radius + 4 + sin(wiggle) * 0.75
        draw_circle(Vector2.ZERO, pulse_radius, color, true)
        var wiggle_resolution = 18

        var wiggle_length = 11.0
        for i in wiggle_resolution:
            var angle = i * TAU / wiggle_resolution
            var dir = Vector2.RIGHT.rotated(angle)
            var base_pos = dir * radius
            var wiggle_offset = sin(wiggle + i) * 5.0
            var end_pos = base_pos + dir * wiggle_length + dir.rotated(PI / 2) * wiggle_offset
            draw_line(base_pos, end_pos, color, 3.5)

    var font = ThemeDB.fallback_font
    draw_string(font,Vector2(0,64),Tentacle.keys()[tentacle_state])

    if (tentacle_state == Tentacle.REACH):
        if (times_pulled_self < 10 && tip.length() > (tentacle_reach * 1.2) + times_pulled_self || wiggle > 5 + times_pulled_self):
            draw_string(font,tip+Vector2(0,-62),get_action_key_label(action2) + " to pull",HORIZONTAL_ALIGNMENT_CENTER,-1,22,Color.BLACK)
            draw_string(font,tip+Vector2(-2,-64),get_action_key_label(action2) + " to pull",HORIZONTAL_ALIGNMENT_CENTER,-1,22,Color.WHITE)


static func get_action_key_label(action: String):
    var xbox_buttons: Array[String] = ["Ⓐ","Ⓑ","Ⓧ","Ⓨ"]
    var events: Array[InputEvent] = InputMap.action_get_events(action)
    var output: String = "press: "
    for event in events:
        if (event is InputEventJoypadButton):
            output += "" + xbox_buttons[event.button_index]
        if (event is InputEventKey):
            output += "/" + (event as InputEventKey).as_text_physical_keycode() + ""
    return output
    pass
