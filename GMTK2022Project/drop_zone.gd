extends Position2D

func select():
	for child in get_tree().get_nodes_in_group("zone"):
		child.deselect()
	
func deselect():
	pass

func draw():
	draw_circle(position, 10, Color(255, 255, 255))
