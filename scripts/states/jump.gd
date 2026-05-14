# jump.gd
extends LimboState

func _enter() -> void:
	agent.set_debug_color(Color("b86a21ff"))

func _update(_delta: float) -> void:
	if agent.is_on_floor():
		get_root().dispatch(&"to_idle")
