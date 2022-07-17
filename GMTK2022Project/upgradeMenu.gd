extends WindowDialog

signal RangePressed
signal RangeHover
signal RangeUnhover
signal DmgPressed 
signal SpeedPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Range_pressed():
	emit_signal("RangePressed") # Replace with function body.


func _on_Range_mouse_entered():
	emit_signal("RangeHover") # Replace with function body.


func _on_Damage_pressed():
	emit_signal("DmgPressed") # Replace with function body.


func _on_Speed_pressed():
	emit_signal("SpeedPressed") # Replace with function body.

func _on_Range_mouse_exited():
	emit_signal("RangeUnhover") # Replace with function body.
