extends Node2D

var map_node
var build_mode = false
var build_valid = false
var build_location
var build_type
var waveNum = 0
var enemy1 = load("res://Gambler.tscn")
var enemy2 = load("res://Slime.tscn")
var enemysSpawned = 0
var wave_pause = true
var r1 = 3
var r2 = 0
var r3 = 0
var wave_increased = false
var dice_starting_pos = Vector2(260, 540)
var die_object = load("res://Dice.tscn")
var zone_object = load("res://drop_zone.tscn")
var first_wave = true

func _ready():
	randomize()
	map_node = get_node("TileMap")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	var new_dice = die_object.instance()
	new_dice.position = dice_starting_pos
	dice_starting_pos.x += 150
	add_child(new_dice)


func _process(delta):
	$UI/HUD/Infobar/HBoxContainer/HP.value = $Vault.health / $Vault.maxHealth
	$UI/HUD/Infobar/HBoxContainer/HP/Label.text = str("Money: " + str($Vault.health))
	$UI/HUD/Infobar/HBoxContainer/RedAmount.text = str(r1)
	$UI/HUD/Infobar/HBoxContainer/GreenAmount.text = str(r2)
	$UI/HUD/Infobar/HBoxContainer/BlueAmount.text = str(r3)
	if build_mode:
		update_tower_preview()
	if Input.is_action_just_pressed("start_wave") and wave_pause == true:
		$EnemyTimer.start()
		wave_pause = false
		enemysSpawned = 0
		get_tree().call_group("die", "set_moveable_false")
	if wave_pause == true and get_tree().get_nodes_in_group("enemies").size() == 0 and wave_increased == false:
		waveNum += 1
		print(waveNum)
		if waveNum % 2 == 0:
			var new_zone = zone_object.instance()
			new_zone.position = dice_starting_pos
			add_child(new_zone)
			var new_dice = die_object.instance()
			new_dice.position = dice_starting_pos
			dice_starting_pos.x += 150
			add_child(new_dice)
		r1 += 1
		r2 += 1
		r3 += 1
		wave_increased = true
		var dices = get_tree().get_nodes_in_group("die")
		for i in dices:
			if i.get_class() == "Node2D":
				if i.is_r1:
					r1 += (randi() % 6) + 1
				elif i.is_r2:
					r2 += (randi() % 6) + 1
				elif i.is_r3:
					r3 += (randi() % 6) + 1
		print("R1: " + str(r1))
		print("R2: " + str(r2))
		print("R3: " + str(r3))
		get_tree().call_group("die", "set_moveable_true")

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func initiate_build_mode(tower_type):
	if(build_mode):
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var title_position = map_node.get_node("TowerExclusion").map_to_world(current_tile)
	title_position.x += map_node.cell_size.x / 2
	title_position.y += map_node.cell_size.y / 2
	
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1:
		get_node("UI").update_tower_preview(title_position, "ad54ff3c")
		build_valid = true
		build_location = title_position
	else:
		get_node("UI").update_tower_preview(title_position, "adff4545")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		## Test to verify player has enough cash
		var new_tower = load("res://Chip Tower.tscn").instance()
		new_tower.position = build_location
		get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(map_node.get_node("TowerExclusion").world_to_map(build_location), 31)
		## deduct cash
		## update cash label

func _on_WaveTimer_timeout():
	wave_pause = true
	if first_wave == true:
		first_wave = false
	else:
		wave_increased = false


func _on_EnemyTimer_timeout():
	if(enemysSpawned <= waveNum):
		var gambler
		if (waveNum > 0) && (randi() % 7 == 0):
			gambler = enemy2.instance()
			enemysSpawned += 2
		else:
			gambler = enemy1.instance()
			enemysSpawned += 1
		$Enemies.add_child(gambler)
	else:
		$EnemyTimer.stop()
		$WaveTimer.start()
		
