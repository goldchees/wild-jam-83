extends GuardState

var max_follow_radius_in_pixels: int = 350


var suspicion : int = 0
var lost_trail : int = 0

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	suspicion += 1
	if guard.global_position.distance_to(guard.target.global_position) > max_follow_radius_in_pixels:
		print(guard.global_position.distance_to(guard.target.global_position))
		lost_trail += 1
	
	if lost_trail > 3000:
		state_finished.emit(RETURN)
		print("EnterReturnState")
	
	if suspicion > 5000:
		state_finished.emit(ATTACK)
		print("EnterAttackState")

func handle_physics_process(delta: float) -> void:
	guard.look_at(guard.target.position)
	if guard.global_position.distance_to(guard.target.global_position) > 150:
		guard.global_position = guard.global_position.move_toward(guard.target.global_position, guard.speed * delta)
		guard.move_and_slide()
		


func enter_state(previous_state : String, data := {}) -> void:
	suspicion = 0
	lost_trail = 0
	guard.velocity = Vector2.ZERO
	
