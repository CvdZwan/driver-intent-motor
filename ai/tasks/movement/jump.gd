@tool
extends BTAction

func _enter() -> void:
	# Fire a single jump pulse
	agent.intent.pulse_jump_pressed()

func _tick(_delta: float) -> Status:
	return SUCCESS
