# PlayerInputDriver.gd
extends Node
class_name PlayerInputDriver

var agent: PlayableCharacter
var intent: Intent

func _physics_process(_delta: float) -> void:
	intent.move_dir = _read_move_dir()

func _read_move_dir() -> Vector3:
	var x := Input.get_axis("move_left", "move_right")
	var z := Input.get_axis("move_up", "move_down")

	var v := Vector2(x, z)
	if v.length() > 1.0:
		v = v.normalized()

	return Vector3(v.x, 0.0, v.y)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		intent.pulse_jump_pressed()
