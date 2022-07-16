extends Node2D

signal base_damage(damage)


export var speed = 150
export var strength = 10
var base_damage = 10
var lowerPath = load("res://LowerCurve.tres")
var upperPath = load("res://UpperCurve.tres")
 
# Called when the node enters the scene tree for the first time.
func _ready():
	var paths = [lowerPath, upperPath]
	$Path2D.curve = paths[randi() % paths.size()]
	add_to_group("enemies")

func _physics_process(delta):
	if unit_offset == 1.0:
		emit_signal("base_damage", base_damage)
		queue_free()
	move(delta)

func move(delta):
	$Path2D/PathFollow2D.set_offset($Path2D/PathFollow2D.get_offset() + speed * delta)



func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("ReachedVault") # Replace with function body.

func on_hit(damage):
	impact()
	hp -= damage
	if hp <= 0:
		on_destroy()

func _on_HitBox_area_entered(area):
	_areaEntered(area)
		
func _areaEntered(area):
	if area.get_name() == "VaultHitDetector":
		queue_free()
	
