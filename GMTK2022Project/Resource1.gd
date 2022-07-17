extends Node2D

var overResource
var diceBoosted = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	overResource = $Sprite/Area2D.get_overlapping_areas()
	var dices = get_tree().get_nodes_in_group("die")
	for i in dices:
		if i.get_class() == "Node2D":
			if i.get_child(0).get_child(0) in overResource:
				diceBoosted = true

func get_resource():
	var boost = 0
	if diceBoosted:
		boost = (randi() % 6) + 1 
	return 1 + boost
