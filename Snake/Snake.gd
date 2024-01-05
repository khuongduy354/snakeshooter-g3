extends Node2D
class_name Snake

onready var parts = $parts
onready var SnakePartScene = preload("res://Snake/SnakePart.tscn")
onready var facing_dir = Vector2.UP

func pop_tail():
	parts.get_child(0).queue_free()

func push_head():
	var prev_head = parts.get_child(parts.get_child_count()-1)
	prev_head.is_head = false

	var part = SnakePartScene.instance()
	var pos = prev_head.global_position + facing_dir * Global.CELL_SIZE
	part.set_head_dir(facing_dir)
	part.connect("pickup",self,"pickup")

	parts.add_child(part)
	part.global_position=pos
	part.is_head =  true
	
func push_tail():
	var spawn_dir: Vector2
	var spawn_pos: Vector2
	
	if parts.get_child_count() == 1: 
		spawn_dir = -facing_dir 
		spawn_pos = parts.get_child(0).global_position + spawn_dir.normalized() * Global.CELL_SIZE
	else: 
		var tail = parts.get_child(0)
		var next_tail = parts.get_child(1)
		spawn_dir = next_tail.global_position.direction_to(tail.global_position)
		spawn_pos = tail.global_position + spawn_dir.normalized() * Global.CELL_SIZE
	
	var new_tail = SnakePartScene.instance()
	new_tail.connect("pickup",self,"pickup")
	
	parts.add_child(new_tail)
	parts.move_child(new_tail,0)
	new_tail.global_position = spawn_pos
	new_tail.is_head = false
	

#func sync_head(): 
#	for part in parts.get_children(): 
#		part.is_head = false
#	var head = 	parts.get_child(parts.get_child_count()-1)
#	head.is_head = true
#	head.set_head_dir(facing_dir)
	
func move(dir: Vector2):
	if dir == -facing_dir and parts.get_child_count() > 1: 
		return
	facing_dir = dir
	pop_tail()
	push_head()
#	sync_head()

func pickup(enem): 
	push_tail()
#	sync_head() 
	
func shoot():
	var bullet = preload("res://Ultility/Bullet.tscn").instance()
	bullet.set_dir(facing_dir)
	var bullet_pos = parts.get_child(parts.get_child_count()-1).global_position + Global.CELL_SIZE * facing_dir
	
	add_child(bullet) 
	bullet.global_position = bullet_pos
