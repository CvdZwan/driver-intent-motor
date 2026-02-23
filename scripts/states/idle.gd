# idle.gd
extends LimboState

func _enter() -> void:
	_set_agent_color(Color("4bffff"))

func _update(_delta: float) -> void:	
	if agent.velocity.y > 0.0:
		get_root().dispatch(&"to_jump")
	
	# stay idle if no movement
	if agent.intent.move_dir == Vector3.ZERO:
		return
	else:
		get_root().dispatch(&"to_move")

func _set_agent_color(color: Color) -> void:
	var mesh := agent.get_node_or_null("MeshInstance3D") as MeshInstance3D
	if mesh == null:
		return

	var mat := mesh.get_active_material(0)
	if mat is StandardMaterial3D:
		mat.albedo_color = color
