extends GuardState

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(_delta: float) -> void:
	if guard.target != null:
		if guard.target.is_possessing:
			state_finished.emit(FOLLOW)
			print("S")
		else:
			state_finished.emit(ATTACK)
			print("X")

func enter_state(previous_state : String, data := {}) -> void:
	guard.velocity = Vector2.ZERO
	
