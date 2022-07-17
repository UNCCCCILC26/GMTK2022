extends KinematicBody2D

var maxHealth = 1000.0
var health = 1000
signal death_signal

func _process(delta):
	if health <= 0:
		emit_signal("death_signal")
		queue_free()

func _on_HitDetector_area_entered(area):
	if area.get_name() == "GamblerHitBox":
		health -= area.get_parent().get_parent().get_parent().get_parent().health

func getHealth():
	return health

func addHealth(num):
	health += num
	if health >= maxHealth:
		health = maxHealth

func lose_health(num):
	health -= num
