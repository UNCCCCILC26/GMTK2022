extends Node2D

export var shootingRange = 100
export var shootingSpeed = .6
export var shootingDmg = 20
var shootingDice = false
var selected = false

var shootingVars = [shootingRange, shootingSpeed, shootingDmg]

var bullet = load("res://Bullet.tscn")
var casino
var overTower

# Called when the node enters the scene tree for the first time.
func _ready():
	casino  = get_parent().get_parent()

func diceBoon():
	var boon = 0
	if shootingDice:
		boon += ((randi() % 6) + 1)
	return boon
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		pass
	else:
		pass
	
	shootingDmg = shootingVars[2] + diceBoon()
	if !(shootingSpeed == shootingVars[1]):
		$ShootingTimer.wait_time = shootingSpeed
	overTower = $Sprite/TowerSelection.get_overlapping_areas()
	var dices = get_tree().get_nodes_in_group("die")
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
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false


func _on_TowerSelection_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
			selected = false
#		var range_texture = Sprite.new()
#		range_texture.position = Vector2()
#		var scaling = shootingRange / 600.0
#		range_texture.scale = Vector2(scaling, scaling)
#		var texture = load("res://Art/Tower Stuff/range_overlay.png")
#		range_texture.texture = texture
#		range_texture.modulate = Color("ad54ff3c")
#
#		var control = Control.new()
#		control.add_child(range_texture, true)
#		control.rect_position = position
#		control.set_name("TowerPreview")
#		add_child(control, true)
#		move_child(get_node("TowerPreview"), 0)
		#$Control.popup() # Replace with function body.
