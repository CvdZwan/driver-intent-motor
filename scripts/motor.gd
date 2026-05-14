extends Node
class_name MovementMotor

var agent: PlayableCharacter
var intent: Intent

@export var move_speed: float = 6.0
@export var jump_speed: float = 6.5

func _physics_process(delta: float) -> void:	
	agent.velocity.x = intent.move_dir.x * move_speed
	agent.velocity.z = intent.move_dir.z * move_speed

	if intent.jump_pressed and agent.is_on_floor():
		agent.velocity.y = jump_speed

	agent.velocity += agent.get_gravity() * delta

	intent.clear_pulses()
	agent.move_and_slide()
