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

func _ready():
	randomize()
	map_node = get_node("TileMap")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])

func _process(delta):
	if build_mode:
		update_tower_preview()

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
	waveNum	+= 1
	$EnemyTimer.start()
	enemysSpawned = 0


func _on_EnemyTimer_timeout():
	if(enemysSpawned <= waveNum):
		var gambler
		print(randi() % 3)
		if (waveNum > 4) && (randi() % 3 == 0):
			gambler = enemy2.instance()
			enemysSpawned += 2
		else:
			gambler = enemy1.instance()
			enemysSpawned += 1
		add_child(gambler)
	else:
		$EnemyTimer.stop()
		$WaveTimer.start()
		