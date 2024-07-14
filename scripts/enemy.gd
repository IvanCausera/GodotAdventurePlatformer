extends Node2D

class_name Enemy

@onready var game_manager: GameManager = %GameManager

const SPEED: int = 60;

@onready var strike_zone: Area2D = $StrikeZone
@onready var killzone: Area2D = $Killzone
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var die_sound_a: AudioStreamPlayer2D = $Sounds/DieSoundA
@onready var die_sound_b: AudioStreamPlayer2D = $Sounds/DieSoundB
@onready var monster_sound_a: AudioStreamPlayer2D = $Sounds/MonsterSoundA
@onready var monster_sound_b: AudioStreamPlayer2D = $Sounds/MonsterSoundB

var direction: int = 1;
var dead: bool = false

func _process(delta: float) -> void:
	if !dead:
		handleMove(delta)
	
func handleMove(delta):
	if ray_cast_right.is_colliding():
		direction = -1;
		animated_sprite.flip_h = true;
		playMosterSound()
	elif ray_cast_left.is_colliding():
		direction = 1;
		animated_sprite.flip_h = false;
		playMosterSound()
	
	position.x += direction * SPEED * delta;
	
func kill():
	game_manager.add_point()
	dead = true
	animated_sprite.play("die")
	playDieSound()

func playMosterSound():
	if monster_sound_a.playing:
		return
	elif monster_sound_b.playing:
		return
	else:
		playRandomSound([monster_sound_a, monster_sound_b])

func playDieSound():
	if die_sound_a.playing:
		return
	elif die_sound_b.playing:
		return
	else:
		playRandomSound([die_sound_a, die_sound_b])
	
func playRandomSound(audio_players: Array[AudioStreamPlayer2D]):
	if audio_players.size() == 0:
		return
	var random_index = randi() % audio_players.size()
	audio_players[random_index].global_position = global_position
	audio_players[random_index].play()
