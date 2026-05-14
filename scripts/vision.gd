extends Node3D

@export var vision_area: Area3D
@export var raycast: RayCast3D
@export var vision_timer: Timer
@export var max_sight_distance: float = 20.0
@export var rotate_with_walk_direction: bool = true
@export var turn_speed: float = 12.0
@export var min_walk_direction_length: float = 0.05
@export var shape_points_positive_z: bool = true

# Optional: aim a bit higher than the player's origin (chest/head)
@export var aim_height: float = 1.2

# If the player is almost straight above/below the ray origin, Vector3.UP becomes colinear.
# In that case we use a stable fallback up vector.
const COLINEAR_DOT_THRESHOLD := 0.98

var agent: PlayableCharacter

func _ready() -> void:
	agent = get_parent() as PlayableCharacter

	if vision_area == null:
		push_error("vision.gd: vision_area is not assigned.")
	if raycast == null:
		push_error("vision.gd: raycast is not assigned.")
	if vision_timer == null:
		push_error("vision.gd: vision_timer is not assigned.")

	if raycast:
		raycast.enabled = true
		# Default direction. Will be overwritten each tick anyway.
		raycast.target_position = Vector3(0, 0, -max_sight_distance)

	if vision_timer:
		vision_timer.timeout.connect(_on_vision_timeout)

func _physics_process(delta: float) -> void:
	_rotate_towards_walk_direction(delta)

func enable_vision() -> void:
	vision_timer.start()
	raycast.enabled = true
	vision_area.visible = true

func disable_vision() -> void:
	vision_timer.stop()
	raycast.enabled = false
	vision_area.visible = false

func flip_area(facing_forward: bool) -> void:
	var s := vision_area.scale
	s.x = abs(s.x) if facing_forward else -abs(s.x)
	vision_area.scale = s

func _rotate_towards_walk_direction(delta: float) -> void:
	if not rotate_with_walk_direction:
		return
	if agent == null or agent.intent == null:
		return

	var walk_dir := agent.intent.move_dir
	walk_dir.y = 0.0

	if walk_dir.length() < min_walk_direction_length:
		return

	walk_dir = walk_dir.normalized()
	var target_yaw := atan2(walk_dir.x, walk_dir.z)
	if not shape_points_positive_z:
		target_yaw = atan2(-walk_dir.x, -walk_dir.z)

	if turn_speed <= 0.0:
		rotation.y = target_yaw
	else:
		rotation.y = lerp_angle(rotation.y, target_yaw, min(turn_speed * delta, 1.0))

func _on_vision_timeout() -> void:
	if vision_area == null or raycast == null:
		return

	var overlaps := vision_area.get_overlapping_bodies()
	if overlaps.is_empty():
		_set_raycast_debug(false)
		return

	var saw_any_player := false

	for body: Node3D in overlaps:
		if body == null:
			continue
		if body == agent:
			continue
		if not body.is_in_group("player"):
			continue

		var target_pos := body.global_position + Vector3.UP * aim_height

		# Best practice: compute direction in world space, guard zero-length,
		# pick a safe up vector, rotate the RayCast, and clamp the cast length.
		var origin := raycast.global_position
		var to_target := target_pos - origin
		var dist := to_target.length()
		if dist < 0.0001:
			continue

		var dir := to_target / dist

		var up := Vector3.UP
		if abs(dir.dot(Vector3.UP)) > COLINEAR_DOT_THRESHOLD:
			# Any axis not parallel to dir works. Pick one that is stable.
			up = Vector3.FORWARD

		raycast.look_at(origin + dir, up)

		# Clamp ray length so you don't "see" beyond your intended max distance.
		raycast.target_position = Vector3(0, 0, -min(dist, max_sight_distance))

		raycast.force_raycast_update()

		if raycast.is_colliding() and raycast.get_collider() == body:
			saw_any_player = true
			if agent != null:
				agent.is_aggro = true
			break

	_set_raycast_debug(saw_any_player)

func _set_raycast_debug(has_los: bool) -> void:
	if raycast == null:
		return
	raycast.debug_shape_custom_color = (Color(0, 1, 0, 1) if has_los else Color(0.7, 0.0, 0.012, 1.0))
