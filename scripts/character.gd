extends CharacterBody3D
class_name PlayableCharacter

enum ControlMode { PLAYER, AI, DISABLED }
@export var control_mode: ControlMode = ControlMode.PLAYER

@onready var player_input_driver: PlayerInputDriver = $PlayerInputDriver
@onready var movement_motor: MovementMotor = $MovementMotor
@onready var intent: Intent = $Intent
@onready var bt_player: BTPlayer = $BTPlayer
@onready var limbo_hsm: LimboHSM = $LimboHSM

@onready var idle: LimboState = $LimboHSM/idle
@onready var jump: LimboState = $LimboHSM/jump
@onready var move: LimboState = $LimboHSM/move

func _ready() -> void:
	movement_motor.agent = self
	movement_motor.intent = intent

	player_input_driver.agent = self
	player_input_driver.intent = intent
	
	set_control_mode(control_mode)
	
	# State machine
	limbo_hsm.initial_state = idle
	limbo_hsm.initialize(self)
	limbo_hsm.set_active(true)
	limbo_hsm.add_transition(idle, move, &"to_move")
	limbo_hsm.add_transition(move, idle, &"to_idle")
	limbo_hsm.add_transition(idle, jump, &"to_jump")
	limbo_hsm.add_transition(jump, idle, &"to_idle")
	
func set_control_mode(mode: ControlMode) -> void:
	control_mode = mode

	var on_player := (mode == ControlMode.PLAYER)
	player_input_driver.set_process(on_player)
	player_input_driver.set_physics_process(on_player)
	player_input_driver.set_process_unhandled_input(on_player)

	var on_ai := (mode == ControlMode.AI)
	bt_player.active = on_ai
