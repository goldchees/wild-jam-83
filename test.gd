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


func _on_level_transition_area_body_entered(body: Node2D) -> void:
	if body is Player or body.is_possessed:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_num = current_scene_file.to_int() + 1
		var next_level_path = "res://scenes/levels/level_" + str(next_level_num) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
