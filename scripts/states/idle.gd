# idle.gd
extends LimboState

func _enter() -> void:
	agent.set_debug_color(Color("4bffff"))

func _update(_delta: float) -> void:
	if agent.velocity.y > 0.0:
		get_root().dispatch(&"to_jump")
		return

	if agent.intent.move_dir != Vector3.ZERO:
		get_root().dispatch(&"to_move")
