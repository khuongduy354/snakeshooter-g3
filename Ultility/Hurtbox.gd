extends Area2D
class_name HurtBox 

signal receive_damage
func _ready(): 
	connect("area_entered",self,"_on_Hurtbox_area_entered")
func _on_Hurtbox_area_entered(area):
	if area is Hitbox: 
		Sound.play("hurt")
		emit_signal("receive_damage",area)
		area.landed()

func set_enable(val: bool): 
	monitorable = val
	monitoring = val
