extends Node
class_name Intent

var move_dir: Vector3 = Vector3.ZERO

var jump_pressed: bool = false

func clear_pulses() -> void:
	jump_pressed = false

func pulse_jump_pressed() -> void:
	jump_pressed = true
