extends Node2D
class_name SnakePart 

signal pickup 
signal received_damage 

export var is_head = true setget set_head

export(int, "up","left","down","right") var head_dir = 0
onready var body_s = $Body
onready var head_s = $Head
onready var hurtbox = $HurtBox

func pickup(enem): 
	emit_signal("pickup",enem)

func set_hurtbox_enable(val:bool): 
	hurtbox.monitorable = val 
	hurtbox.monitoring = val
	
func set_head(val):
	is_head = val 
	adjust_sprite()
	
func set_head_dir(dir: Vector2): 
	var dirs = [Vector2.UP,Vector2.LEFT,Vector2.DOWN,Vector2.RIGHT]	
	for i in range(0, dirs.size()): 
		if dir == dirs[i]: 
			head_dir = i

func _ready():
	adjust_sprite()

func adjust_sprite(): 
	body_s.visible = !is_head 
	head_s.visible = is_head
#	adjust_head()
	
func adjust_head(): 
	if !is_head:
		return
	var dirs = [8,16,24,32]
	head_s.region_rect.position.x = dirs[head_dir]




func _on_HurtBox_receive_damage(hitbox):
	emit_signal("received_damage",hitbox)
