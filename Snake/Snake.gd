extends Node2D
class_name Snake

signal die

onready var parts = $parts
onready var SnakePartScene = preload("res://Snake/SnakePart.tscn")
onready var facing_dir = Vector2.UP
var head_pos = Vector2.ZERO 
var powerup: PowerUp = null 

func pop_tail():
	parts.get_child(0).queue_free()
	
func _on_received_damage(hitbox:Hitbox): 
	for i in range(hitbox.damage): 
		if parts.get_child_count() == 0: 
			emit_signal("die")
			return
		pop_tail()

func add_part(part: SnakePart, gpos, is_head): 
	part.connect("pickup",self,"pickup")
	part.connect("received_damaged",self,"_on_received_damage")
	parts.add_child(part)
	part.global_position = gpos 
	part.is_head = is_head

	if is_head: 
		head_pos = part.global_position
	
func push_head():
	var prev_head = parts.get_child(parts.get_child_count()-1)
	prev_head.is_head = false

	var part = SnakePartScene.instance()
	var pos = prev_head.global_position + facing_dir * Global.CELL_SIZE
	part.set_head_dir(facing_dir)

	add_part(part,pos,true)
	
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
	
	add_part(new_tail,spawn_pos,false)
	parts.move_child(new_tail,0)

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


func pickup(stuff): 
	if stuff is PowerUp: 
		stuff.connect("expire",self,"power_expired")
		powerup = stuff
	else: 
		push_tail()
func power_expired(): 
	print("expired")
	powerup = null
	
func shoot(): 
	if powerup: 
		if powerup.power_type == PowerUp.PTypes.RAPID: 
			default_shoot(3)
		if powerup.power_type == PowerUp.PTypes.SPREAD: 
			pass
	else: 
		default_shoot()
		
func default_shoot(speed_mul = 1):
	var bullet = preload("res://Ultility/SnakeBullet.tscn").instance()
	bullet.set_dir(facing_dir)
	var bullet_pos = parts.get_child(parts.get_child_count()-1).global_position + Global.CELL_SIZE * facing_dir
	bullet.speed *= speed_mul
	
	add_child(bullet) 
	bullet.global_position = bullet_pos
