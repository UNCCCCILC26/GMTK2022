extends Node2D

var selected = false
var rest_point
var old_rest_point
var rest_nodes = []
var child_name
var unq_count = 0
var is_unique = true

func _ready():
	add_to_group("die")
	goToClosest()
	
func updateList():
	rest_nodes = get_tree().get_nodes_in_group("zone")

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)

func goToClosest():
	updateList()
	for child in rest_nodes:
		var shortest_dist = 75
		var distance = global_position.distance_to(child.global_position)
		if distance < shortest_dist:
			child_name = child.get_parent().get_parent().get_name()
			var dices = get_tree().get_nodes_in_group("die")
			for i in dices:
				if i.get_class() == "Node2D":
					if child_name == i.child_name:
						unq_count += 1
						if unq_count > 1:
							is_unique = false
					if is_unique == true:
						child.select()
						rest_point = child.global_position
						shortest_dist = distance
					else:
						rest_point = old_rest_point
		is_unique = true
		unq_count = 0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			old_rest_point = rest_point
			goToClosest()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
