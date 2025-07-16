extends GuardState

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(delta: float) -> void:
	if guard.pathway == null:
		guard.aim = guard.aim.rotated(1 * delta)
	else:
		pass
	guard.current_position = guard.global_position
	
	if guard.target != null:
		if guard.target.is_possessed:
			state_finished.emit(FOLLOW)
			print("EnterFollowState")
		else:
			state_finished.emit(ATTACK)
			print("EnterAttackState")

func enter_state(previous_state : String, data := {}) -> void:
	guard.target = null
