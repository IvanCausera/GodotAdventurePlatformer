extends CharacterBody2D

class_name Player

# https://youtu.be/LOhfqjmasi0?si=eWLfjlX4v0TjTwhc&t=2064
const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var run_sound: AudioStreamPlayer2D = $Sounds/RunSound
@onready var jump_sound: AudioStreamPlayer2D = $Sounds/JumpSound
@onready var die_sound: AudioStreamPlayer2D = $Sounds/DieSound
@onready var fall_sound: AudioStreamPlayer2D = $Sounds/FallSound
@onready var turn_sound: AudioStreamPlayer2D = $Sounds/TurnSound

var delta: float;
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta: float) -> void:
	delta = _delta
	addGravity();
	handleJump();
	handleMovement();
	move_and_slide()

func addGravity():
	if not is_on_floor():
		velocity.y += gravity * delta

func handleJump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		makeJump()

func makeJump():
	playJumpSound()
	velocity.y = JUMP_VELOCITY
		
func handleMovement():
	var direction := Input.get_axis("move_left", "move_right")
	setSpritDirection(direction)
	setVelocity(direction)
	setAnimation(direction)

func setSpritDirection(direction: float):
	if direction > 0:
		if animated_sprite.is_flipped_h() != false:
			playTurnSound()
		animated_sprite.flip_h = false;
	elif direction < 0:
		if animated_sprite.is_flipped_h() != true:
			playTurnSound()
		animated_sprite.flip_h = true;

func setVelocity(direction: float):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func setAnimation(direction: float):
	if not is_on_floor():
		animated_sprite.play("jump")
		return
	if direction == 0:
		run_sound.stop()
		animated_sprite.play("idle")
	else:
		playRunSound()
		animated_sprite.play("run")

func playJumpSound():
	if jump_sound.playing:
		return
	else:
		jump_sound.play()

func playRunSound():
	if run_sound.playing:
		return
	else:
		run_sound.play()

func playTurnSound():
	if turn_sound.playing:
		return
	else:
		turn_sound.play()
