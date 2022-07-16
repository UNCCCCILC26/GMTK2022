extends Node2D
export var speed = 150
export var strength = 10
var lowerPath = load("res://LowerCurve.tres")
var upperPath = load("res://UpperCurve.tres")
 
# Called when the node enters the scene tree for the first time.
func _ready():
	var paths = [lowerPath, upperPath]
	$Path2D.curve = paths[randi() % paths.size()]

func _physics_process(delta):
	move(delta)

func move(delta):
	$Path2D/PathFollow2D.set_offset($Path2D/PathFollow2D.get_offset() + speed * delta)



func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("ReachedVault") # Replace with function body.


func _on_HitBox_area_entered(area):
	_areaEntered(area)
		
func _areaEntered(area):
	if area.get_name() == "VaultHitDetector":
		queue_free()
	