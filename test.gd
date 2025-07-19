extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $transition/ColorRect
@onready var player: Player = $Player

func _ready() -> void:
	color_rect.show()
	animation_player.play("fade_to_normal")
	player.global_position = $PlayerSpawn.global_position
	player.player_died.connect(handle_death)
	get_tree().paused = false
	print('ready')

func handle_death():
	print('death')
	animation_player.play('fade_to_black')
	#get_tree().paused = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_black":
		print('reload')
		get_tree().reload_current_scene()
