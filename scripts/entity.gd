class_name Entity
extends Actor

@onready var entity_energy_bar: ProgressBar = $entityEnergyBar

var died = false 

func _process(delta: float) -> void:
	if entity_energy_bar.value <= 0 && !died:
		died = true
		print(name + "died")

func lose_energy():
	entity_energy_bar.value -= 0.1
