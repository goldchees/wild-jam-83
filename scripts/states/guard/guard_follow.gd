extends GuardState

var suspicion : int

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	suspicion += 1
	
	if suspicion > 1000:
		state_finished.emit(ATTACK)

func handle_physics_process(delta: float) -> void:
	guard.look_at(guard.target.position)
	if guard.global_position.distance_to(guard.target.global_position) > 150:
		guard.global_position = guard.global_position.move_toward(guard.target.global_position, guard.speed * delta)
		guard.move_and_slide()

func enter_state(previous_state : String, data := {}) -> void:
	guard.velocity = Vector2.ZERO
	
