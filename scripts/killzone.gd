extends Area2D

@onready var timer: Timer = $Timer

@export var is_fall: bool = false

func _on_body_entered(body: Player) -> void:
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	startDieSound(body)
	timer.start()

func startDieSound(body: Player):
	if is_fall:
		body.fall_sound.play()
	else:
		body.die_sound.play()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1;
	get_tree().reload_current_scene();
