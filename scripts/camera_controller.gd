extends Camera2D

@export var target: Node2D
var camera_move_speed = 400

func _ready():
    if !target: print("Camera: no target found")

func _process(delta):
    if !target: return
    
    var distance = global_position.distance_to(target.global_position)

    #todo: more sophisticated following
    if (distance > 100):
        global_position = global_position.move_toward(target.global_position, delta * camera_move_speed)
