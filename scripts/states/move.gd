# walk.gd
extends LimboState

func _enter() -> void:
	_set_agent_color(Color("b44c45"))

func _update(_delta: float) -> void:
	if agent.intent.move_dir == Vector3.ZERO:
		get_root().dispatch(&"to_idle")

func _set_agent_color(color: Color) -> void:
	var mesh := agent.get_node_or_null("MeshInstance3D") as MeshInstance3D
	if mesh == null:
		return

	var mat := mesh.get_active_material(0)
	if mat is StandardMaterial3D:
		mat.albedo_color = color
