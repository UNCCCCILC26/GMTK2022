extends Node2D

export var shootingRange = 100
export var shootingSpeed = .6
export var shootingDmg = 20
var shootingDice = false
var selected = false
var speedUpgrades = 0
var dmgUpgrades = 0
var rangeUpgrades = 0

var shootingVars = [shootingRange, shootingSpeed, shootingDmg]

var bullet = load("res://Bullet.tscn")
var casino
var overTower
var build_location
var build_valid
var range_texture = Sprite.new()
var texture = load("res://Art/Tower Stuff/range_overlay.png")


var rangeCost
var dmgCost
var speedCost


# Called when the node enters the scene tree for the first time.
func _ready():
	casino  = get_parent().get_parent()
	update_popup()

func diceBoon():
	var boon = 0
	if shootingDice:
		boon += ((randi() % 6) + 1)
	return boon
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_popup()
	if selected:
		var scaling = shootingRange / 600.0
		range_texture.scale = Vector2(scaling, scaling)
		range_texture.texture = texture
		var realPosition = $Sprite/TowerSelection.position
		range_texture.position.x = realPosition.x
		range_texture.position.y = realPosition.y		
		add_child(range_texture)
	else:
		remove_child(range_texture)
	
	shootingDmg = shootingVars[2] + diceBoon()
	if !(shootingSpeed == shootingVars[1]):
		$ShootingTimer.wait_time = shootingSpeed
		shootingVars[1] = shootingSpeed
	
	overTower = $Sprite/TowerSelection.get_overlapping_areas()
	var dices = get_tree().get_nodes_in_group("die")
	shootingDice = false
	for i in dices:
		if i.get_class() == "Node2D":
			if i.get_child(0).get_child(0) in overTower:
				shootingDice = true

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
			
func update_popup():
	rangeCost = (rangeUpgrades * 5) + 1
	dmgCost = (dmgUpgrades * 5) + 1
	speedCost = (speedUpgrades * 5) + 1
	$Control/Range/Cost.text = "Cost: " + str(rangeCost) + " Blue\n" + str(rangeCost * 15) + " Money"
	$Control/Damage/Cost.text = "Cost: " + str(dmgCost) + " Red\n" + str(dmgCost * 15) + " Money"
	$Control/Speed/Cost.text = "Cost: " + str(speedCost) + " Green\n" + str(speedCost * 15) + " Money"
	
	$Control/Range/Upgrade.text = str(shootingRange) + " -> " + str(shootingRange + max(25 - rangeUpgrades, 5))
	$Control/Damage/Upgrade.text = str(shootingVars[2]) + " -> " + str(shootingVars[2]  + max(10 - shootingVars[2], 2))
	$Control/Speed/Upgrade.text = str(shootingSpeed) + " -> " + str(shootingSpeed - max(.15 - (speedUpgrades * .1), .01))
	

func _input(event):
	if event.is_action_released("ui_cancel"):
		selected = false
		$Control.hide()


func _on_TowerSelection_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		selected = true
		
		var popPosition = Vector2($Sprite/TowerSelection.global_position.x + 70, $Sprite/TowerSelection.global_position.y)
		$Control.popup(Rect2(popPosition.x, popPosition.y, 420, 300))

func enoughMon(cost):
	return get_parent().get_parent().get_node("Vault").health > cost
func subtractMon(cost):
	return get_parent().get_parent().get_node("Vault").lose_health(cost)

func _on_Control_DmgPressed():
	if(get_parent().get_parent().r3 > dmgCost and enoughMon(dmgCost * 15)):
		get_parent().get_parent().r3 -= dmgCost
		subtractMon(dmgCost * 15)
		shootingDmg += max(10 - shootingVars[2], 2)
		dmgUpgrades += 1
		shootingVars[2] = shootingDmg


func _on_Control_RangeHover():
	shootingRange = shootingVars[0] + max(25 - rangeUpgrades, 5) # Replace with function body.

func _on_Control_RangeUnhover():
	shootingRange = shootingVars[0]

func _on_Control_RangePressed():
	if(get_parent().get_parent().r1 > rangeCost) and enoughMon(rangeCost * 15):
		get_parent().get_parent().r1 -= rangeCost
		subtractMon(rangeCost * 15)
		shootingVars[0] = shootingRange
		rangeUpgrades += 1


func _on_Control_SpeedPressed():
	if(get_parent().get_parent().r2 > speedCost) and enoughMon(speedCost * 15):
		get_parent().get_parent().r2 -= speedCost
		subtractMon(speedCost * 15)
		shootingSpeed -= max(.15 - (speedUpgrades * .1), .01)
		speedUpgrades += 1

