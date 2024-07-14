extends Area2D

@export var enemy: Enemy;

func _on_body_entered(body: Player) -> void:
	enemy.killzone.queue_free()
	enemy.kill()
	body.makeJump()
	enemy.strike_zone.queue_free()
