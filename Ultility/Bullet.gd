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
	if Global.is_out_border(global_position): 
		queue_free()
	$bullet_speed.wait_time = (1.0/speed)    
	move()


func _on_Hitbox_landed():
	explode() 
	queue_free()
	
func explode(): 
	var expl = preload("res://UI/Explosion1.tscn").instance()
	get_tree().root.add_child(expl)
	expl.global_position = global_position 
	expl.emit()
