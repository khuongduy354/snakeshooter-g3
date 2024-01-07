extends Area2D

export var speed = 30 # tiles/sec
export var damage = 1 setget set_damage 

func set_damage(val): 
	damage = val 
	$Hitbox.damage = damage 

var dir = Vector2.ZERO 

func _ready(): 
	set_as_toplevel(true)
	
func set_dir(_dir: Vector2): 
	dir = _dir
	$bullet_speed.wait_time = (1.0/speed)    
	
	
func move(): 
	global_position += dir * Global.CELL_SIZE

func _on_bullet_speed_timeout():
	$bullet_speed.wait_time = (1.0/speed)    
	move()
