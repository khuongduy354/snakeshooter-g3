extends Node2D
class_name Snake

signal die

onready var parts = $parts
onready var SnakePartScene = preload("res://Snake/SnakePart.tscn")
onready var facing_dir = Vector2.LEFT
onready var BulletScene = preload("res://Ultility/SnakeBullet.tscn")
onready var animp = $AnimationPlayer
var head_pos = Vector2.ZERO 
var powerup: PowerUp = null 

func _ready(): 
	for part in parts.get_children(): 
		part.connect("received_damage",self,"_on_received_damage")
		part.is_head = false
	var head = parts.get_child(parts.get_child_count()-1)
	head.is_head = true 
	head_pos = head.global_position

func pop_tail():
	var tail = parts.get_child(0)
	tail.queue_free()
func _on_received_damage(hitbox): 
	for i in range(hitbox.damage): 
		if parts.get_child_count() == 1: 
			die()
			return
		parts.get_child(0).white_flash()
		

func add_part(part: SnakePart, gpos, is_head): 
	part.connect("pickup",self,"pickup")
	part.connect("received_damage",self,"_on_received_damage")
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
	
	# check bites itself 
	for _part in parts.get_children(): 
		if _part.global_position == pos: 
			die()
			return 
#	part.set_head_dir(facing_dir)

	add_part(part,pos,true)
	
func die(): 
	emit_signal("die")
	
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
	if dir == -facing_dir:
		return
	facing_dir = dir
	if Global.is_out_border(head_pos + Global.CELL_SIZE * facing_dir): 
		return
	pop_tail()
	push_head()
#	sync_head()


func pickup(stuff): 
	if stuff is PowerUp: 
		if powerup: 
			powerup.cleanup()
			powerup.disconnect("expire",self,"power_expired")
		powerup = stuff
		powerup.connect("expire",self,"power_expired")
	else: 
		Sound.play("grow")
		push_tail()
func power_expired(): 
	print(powerup.power_type)
	print("expired")
	powerup = null
	
func shoot(): 
	Sound.play("shoot")
	if powerup: 
		if powerup.power_type == PowerUp.PTypes.RAPID: 
			default_shoot(3)
		if powerup.power_type == PowerUp.PTypes.SPREAD: 
			spread_shoot() 
		else: 
			default_shoot()
	else: 
		default_shoot()
func spread_shoot(): 
	var mbullet = BulletScene.instance()
	var bullet1 = BulletScene.instance()
	var bullet2 = BulletScene.instance()

	
	var dir1 = facing_dir.rotated(PI/4)
	var dir2 = facing_dir.rotated(-PI/4)
	mbullet.set_dir(facing_dir)
	bullet1.set_dir(dir1)
	bullet2.set_dir(dir2)
	
	var pos1 = head_pos + Global.CELL_SIZE * dir1 
	var pos2 = head_pos + Global.CELL_SIZE * dir2
	var mpos = head_pos + Global.CELL_SIZE * facing_dir
	
	add_child(mbullet)
	add_child(bullet1)
	add_child(bullet2)
	
	mbullet.global_position = mpos
	bullet1.global_position = pos1 
	bullet2.global_position = pos2 
	
func default_shoot(speed_mul = 1):
	var bullet = preload("res://Ultility/SnakeBullet.tscn").instance()
	bullet.set_dir(facing_dir)
	var bullet_pos = head_pos + Global.CELL_SIZE * facing_dir
	bullet.speed *= speed_mul
	
	add_child(bullet) 
	bullet.global_position = bullet_pos
