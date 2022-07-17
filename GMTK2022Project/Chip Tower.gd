extends Node2D

export var shootingRange = 100
export var shootingSpeed = .8
export var shootingDmg = 25

var shootingVars = [shootingRange, shootingSpeed, shootingDmg]

var bullet = load("res://Bullet.tscn")
var casino

# Called when the node enters the scene tree for the first time.
func _ready():
	casino  = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !(shootingSpeed == shootingVars[1]):
		$ShootingTimer.wait_time = shootingSpeed

func _on_ShootingTimer_timeout():
	var furthestInRange = 0
	var furthestEnemy
	var enemies = casino.get_node("Enemies")
	if enemies == null:
		return
	for enemy in enemies.get_children():
		var distance = position.distance_to(enemy.get_child(0).get_child(0).position)
		if distance <= shootingRange:
			if distance >= furthestInRange:
				furthestInRange = distance
				furthestEnemy = enemy
	if(furthestEnemy):
		var currBull = bullet.instance()
		currBull.addTarget(furthestEnemy, shootingDmg)
		currBull.position = position
		casino.add_child(currBull)
			
