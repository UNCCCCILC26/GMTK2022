extends MarginContainer

func _ready():
	get_node("TextureRect/Back").connect("pressed", self, "on_back_pressed")

func on_back_pressed():
	queue_free()
