@tool
extends BTAction

## Name of the node to search for.
@export var node_name: StringName

## Blackboard variable in which the task will store the acquired node.
@export var output_var: StringName = &"target"

func _generate_name() -> String:
	return "GetNodeByName \"%s\"  ➜%s" % [
		node_name,
		LimboUtility.decorate_var(output_var)
	]
	
func _tick(_delta: float) -> Status:
	var root := agent.get_tree().root
	var result := _find_node_recursive(root)

	if result == null:
		return FAILURE

	blackboard.set_var(output_var, result)
	return SUCCESS

func _find_node_recursive(node: Node) -> Node:
	if node.name == node_name:
		return node

	for child in node.get_children():
		var found := _find_node_recursive(child)
		if found != null:
			return found

	return null
