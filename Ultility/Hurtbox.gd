extends Area2D
class_name HurtBox 

signal receive_damaged

func _on_Hurtbox_area_entered(area):
	if area is Hitbox: 
		emit_signal("receive_damaged",area)

func set_enable(val: bool): 
	monitorable = val
	monitoring = val
