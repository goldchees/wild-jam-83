extends Area2D
@export var speed = 300

func _process(delta: float) -> void:
	var rotation_vector = Vector2.RIGHT.rotated(rotation)
	position += rotation_vector * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pass
	queue_free()
