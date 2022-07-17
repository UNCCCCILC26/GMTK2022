extends Node2D

var selected = false
var rest_point
var rest_nodes = []
var is_moveable = true
var is_r1 = false
var is_r2 = false
var is_r3 = false
var child_name
var unq_count = 0
var is_unique = true

func _ready():
	add_to_group("die")
	updateList()
	
func updateList():
	rest_nodes = get_tree().get_nodes_in_group("zone")
	goToClosest()

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)


func set_moveable_false():
	is_moveable = false

func set_moveable_true():
	is_moveable = true
	
func goToClosest():
	for child in rest_nodes:
		var shortest_dist = 75
		var distance = global_position.distance_to(child.global_position)
		if distance < shortest_dist:
			child_name = child.get_name()
			var dices = get_tree().get_nodes_in_group("die")
			for i in dices:
				if i.get_class() == "Node2D":
					if child_name == i.child_name:
						print("~~~~~~~~")
						print(unq_count)
						unq_count += 1
						print(unq_count)
						if unq_count > 1:
							is_unique = false
					if is_unique == true:
						print(name)
						print(child_name)
						child.select()
						is_r3 = false
						is_r2 = false
						is_r1 = false
						match child.get_name().left(7):
							"R1 Drop":
								is_r1 = true
							"R2 Drop":
								is_r2 = true
							"R3 Drop":
								is_r3 = true
						rest_point = child.global_position
						print(rest_point)
						shortest_dist = distance
			is_unique = true
			unq_count = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			updateList()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click") and is_moveable == true:
		selected = true
