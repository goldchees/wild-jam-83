extends GuardState

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(delta: float) -> void:
	guard.global_position = guard.global_position.move_toward(guard.current_position, guard.speed * delta)
	guard.move_and_slide()
	
	if guard.global_position == guard.current_position:
		state_finished.emit(IDLE)
		print("EnterIdleState")

func enter_state(previous_state : String, data := {}) -> void:
	guard.velocity = Vector2.ZERO
