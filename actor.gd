class_name Actor
extends CharacterBody2D

@export var speed = 400

func move(input_vector: Vector2):
	velocity = input_vector * speed
	move_and_slide()
	pass
