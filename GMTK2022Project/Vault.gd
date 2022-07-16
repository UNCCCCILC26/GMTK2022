extends KinematicBody2D

var health = 100
signal death_signal

func _process(delta):
	if health <= 0:
		emit_signal("death_signal")
		queue_free()

func _on_HitDetector_area_entered(area):
	if area.get_name() == "GamblerHitBox":
		health -= 10

func getHealth():
	return health

func addHealth(num):
	health += num

func lose_health(num):
	health -= num
