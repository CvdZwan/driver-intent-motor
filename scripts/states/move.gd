# move.gd
extends LimboState

func _enter() -> void:
	agent.set_debug_color(Color("b44c45"))

func _update(_delta: float) -> void:
	if agent.intent.move_dir == Vector3.ZERO:
		get_root().dispatch(&"to_idle")
