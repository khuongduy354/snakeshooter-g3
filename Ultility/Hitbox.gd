extends Area2D
class_name Hitbox 
signal landed

onready var damage = owner.damage

func landed(): 
	emit_signal("landed")
