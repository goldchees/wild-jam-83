extends Node2D

@onready var body: CharacterBody2D = get_parent()

@export var enabled = true

var dash_length = 200
var dash_destination: Vector2
var dash_cooldown: float = 0
var dash_cooldown_duration: float = 2

func on_dash_action():
    if (dash_cooldown == 0):
        dash()

func _process(delta):
    dash_cooldown = move_toward(dash_cooldown,0,delta)

    var q = PhysicsRayQueryParameters2D.create(body.global_position,body.position + body.aim * dash_length)
    var result = get_world_2d().direct_space_state.intersect_ray(q)
    dash_destination = body.global_position + body.aim.normalized() * dash_length
    if (result):
        dash_destination = result.position

func dash(): # more of a blink, but...
    body.global_position = dash_destination
    dash_cooldown = dash_cooldown_duration
