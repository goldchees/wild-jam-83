class_name Entity
extends Actor

@onready var entity_energy_bar: ProgressBar = $entityEnergyBar

func _process(delta: float) -> void:
	if entity_energy_bar.value <= 0:
		print("die")

func lose_energy():
	entity_energy_bar.value -= 0.1
