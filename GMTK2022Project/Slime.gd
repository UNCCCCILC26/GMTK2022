extends "res://Gambler.gd"



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealth = 400
	speed = 200
	
	health = maxHealth # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GamblerHitBox_area_entered(area):
	_on_HitBox_area_entered(area)

func harm(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
