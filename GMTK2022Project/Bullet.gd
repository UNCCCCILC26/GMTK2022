extends RigidBody2D

var aimTarget
var damage
export var speed = 30

func addTarget(target, dmg):
	damage = dmg
	aimTarget = target.get_child(0).get_child(0).position

func _physics_process(delta):
	var angle = position.angle_to_point(aimTarget)
	var translateBy = Vector2(speed, 0)
	translateBy = translateBy.rotated(angle)
	position.x -= translateBy.x
	position.y -= translateBy.y
	if get_parent().get_node("Enemies").get_child_count() == 0:
		queue_free()
	
func _on_Area2D_area_entered(area):
	if area.get_name() == "GamblerHitBox":
		area.get_parent().get_parent().get_parent().get_parent().harm(damage)
		queue_free()
	
	
