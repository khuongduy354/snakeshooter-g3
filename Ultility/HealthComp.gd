extends Node2D
class_name HealthComponent

signal health_changed 

onready var max_health = owner.max_health 
onready var health = owner.max_health setget set_health 

func set_health(val): 
	health = val 
	emit_signal("health_changed",health)
