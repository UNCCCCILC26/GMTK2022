extends MarginContainer

const first_scene = preload("res://Casino.tscn")

func _ready():
	get_node("TextureRect/Start").connect("pressed", self, "on_start_pressed")
	get_node("TextureRect/Exit").connect("pressed", self, "on_exit_pressed")

func on_start_pressed():
	get_parent().add_child(first_scene.instance())
	queue_free()

func on_exit_pressed():
	get_tree().quit()

