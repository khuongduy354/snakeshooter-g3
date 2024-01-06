extends Node2D
class_name Enemy

export var max_health = 1
export var damage = 1
export var die_frame = 43

onready var HPComp = $HealthComp
onready var sprite = $Sprite
var p: Snake = null


func _initialize_(_p:Snake): 
	p = _p
	

func _on_HealthComp_health_changed(val):
	if val <= 0: 
		die()
		
func die(): 
	sprite.frame = die_frame
	$Hurtbox.set_enable(false)
	$PickUp.monitorable = true
	$PickUp.monitoring = true

func _on_PickUp_area_entered(area):
	if area.is_in_group("snake"): 
		area.owner.pickup(self)
		self.queue_free()


func _on_Hurtbox_receive_damaged(hitbox):
	HPComp.health -= hitbox.damage 
	
func split_to_8_dir(dir:Vector2): 
	var dirs = [Vector2.UP, Vector2.DOWN,Vector2.LEFT, Vector2.RIGHT, Vector2(-1,-1),Vector2(-1,1), Vector2(1,-1),Vector2(1,1)]
	var result = dirs[0]
	var min_angle = dir.angle_to(dirs[0])
	
	for expected_dir in dirs: 
		if dir.angle_to(expected_dir) < min_angle: 
			result = expected_dir 
			min_angle = dir.angle_to(expected_dir)
	
	return result.normalized()
	
func shoot(): 
	var bullet = preload("res://Ultility/EnemBullet.tscn").instance()
	var dir = split_to_8_dir(global_position.direction_to(p.head_pos))
	var pos = global_position + dir * Global.CELL_SIZE
	bullet.set_dir(dir)
	
	add_child(bullet)
	bullet.global_position = pos 
func _on_shoot_timeout():
	if p: 
		shoot()
