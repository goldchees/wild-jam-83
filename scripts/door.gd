class_name Door
extends Node2D

@onready var left: AnimatableBody2D = $left
@onready var right: AnimatableBody2D = $right
@onready var area: Area2D = $area

@export var open_distance := 186
@export var closed_distance := 64
@export var close_time := 0.2
@export var locked = false

var tween: Tween
var is_open := false

func toggle():
    if is_open:
        close()
    else:
        open()

func _ready():
    area.body_entered.connect(entered)
    area.body_exited.connect(exited)

    pass

func entered(_body: Node2D):
    if locked: return
    if !is_open:
        open()

func exited(_body: Node2D):
    if locked: return
    var bodies = area.get_overlapping_bodies()
    if bodies.is_empty():
        close()


func open():
    is_open = true
    slide(open_distance)

func close():
    is_open = false
    slide(closed_distance)


func slide(destination: float):
    var t = close_time
    if tween:
        if tween.is_running():
            t -= tween.get_total_elapsed_time()
        tween.kill()

    tween = get_tree().create_tween()
    
    tween.set_parallel(true)
    tween.tween_property(left,"position",Vector2(-destination,0),t)
    tween.tween_property(right,"position",Vector2(destination,0),t)
