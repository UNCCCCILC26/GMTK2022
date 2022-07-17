extends Node2D

export var shootingRange = 200
export var shootingSpeed = .4
export var shootingDmg = 50

var shootingVars = [shootingRange, shootingSpeed, shootingDmg]

var bullet = load("res://Bullet.tscn")
var casino
var overTop
var overBot

# Called when the node enters the scene tree for the first time.
func _ready():
	casino  = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !(shootingSpeed == shootingVars[1]):
		$ShootingTimer.wait_time = shootingSpeed
	overTop = $Sprite/TopDrop.get_overlapping_areas()
	var dices = get_tree().get_nodes_in_group("die")
	for i in dices:
		if i.get_class() == "Node2D":
			if i.get_child(0).get_child(0) in overTop:
				print("HERE")

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
			
