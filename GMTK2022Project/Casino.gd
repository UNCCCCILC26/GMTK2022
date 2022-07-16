extends Node2D

export(PackedScene) var enemy

func _ready():
	randomize() # Replace with function body.

func _on_WaveTimer_timeout():
	pass # Replace with function body.


func _on_EnemyTimer_timeout():
	var gambler = enemy.instance()
	add_child(gambler)
	print(get_child_count())
