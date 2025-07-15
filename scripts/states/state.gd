class_name State extends Node

signal state_finished(next_state : String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass

func handle_process(_delta: float) -> void:
	pass

func handle_physics_process(_delta: float) -> void:
	pass

func enter_state(previous_state : String, data := {}) -> void:
	pass
	
func exit_state() -> void:
	pass
