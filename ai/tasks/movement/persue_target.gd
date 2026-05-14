@tool
extends BTAction
## Move straight toward the target on the XZ plane until within desired distance.

@export var target_var: StringName = &"target" # expecting Node3D

# Stop this far away from the target (meters). Set to 0 to go right on top of it.
@export var desired_distance: float = 1.5

# Extra slack to avoid jitter (meters).
@export var tolerance: float = 0.25

func _generate_name() -> String:
	return "Pursue3D %s" % [LimboUtility.decorate_var(target_var)]

func _enter() -> void:
	# Stop any previous movement intent when task starts
	agent.intent.move_dir = Vector3.ZERO

func _tick(_delta: float) -> Status:
	var target := blackboard.get_var(target_var, null) as Node3D
	if not is_instance_valid(target):
		agent.agent_intent.move_dir = Vector3.ZERO
		return FAILURE

	# XZ-only distance check
	var a: Vector3 = agent.global_position
	var b: Vector3 = target.global_position
	a.y = 0.0
	b.y = 0.0

	var dist: float = a.distance_to(b)

	if dist <= (desired_distance + tolerance):
		agent.intent.move_dir = Vector3.ZERO
		return SUCCESS

	# Move directly toward target
	var dir: Vector3 = b - a
	if dir.length_squared() < 0.000001:
		agent.intent.move_dir = Vector3.ZERO
		return RUNNING

	agent.intent.move_dir = dir.normalized()
	return RUNNING
