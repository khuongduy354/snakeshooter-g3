extends Node2D
class_name Enemy

signal die

enum EnemTypes{ 
	LIGHT, DAME, TANK
}
export(int,"LIGHT","DAME","TANK") var enem_type = EnemTypes.LIGHT
export var max_health = 1
export var die_frame = 43
export var change_dir_interval = 5
export var speed = 1
export var damage = 1 

onready var HPComp = $HealthComp
onready var sprite = $Sprite
onready var animp = $AnimationPlayer 
var p: Snake = null
var rng = RandomNumberGenerator.new() 

var dir = Vector2.RIGHT
var curr_anim = "walk"
var death = false 
func play_anim(_curr_anim): 
	curr_anim = _curr_anim
	animp.play(curr_anim)

func load_stat(): 
	var res_paths = ["res://Enemy/LightEnemy.tres","res://Enemy/DameEnemy.tres","res://Enemy/TankEnemy.tres"]
	var res = load(res_paths[enem_type]) as EnemyStat
	max_health = res.max_health 
	HPComp.max_health = max_health
	HPComp.health = max_health
	die_frame = res.die_frame 
	sprite.texture = res.sprite
	speed = res.speed
	damage = res.damage
	$move.wait_time = 1.0/speed
	$shoot.wait_time = 20.0/damage

func _ready():
	rng.randomize()
	load_stat()
	play_anim("walk")
	$change_dir.wait_time = change_dir_interval

func _initialize_(_p:Snake): 
	p = _p

func _on_HealthComp_health_changed(val):
	if val <= 0 and !death: 
		die()
		
func die(): 
	death = true 
	$move.stop()
	play_anim("die")
	sprite.frame = die_frame
	$Hurtbox.monitoring = false 
	$Hurtbox/CollisionShape2D.set_deferred("disabled",true)
	$PickUp.monitorable = true
	$PickUp.monitoring = true
	$shoot.stop()
	emit_signal("die")
	Global.emit_signal("enem_killed")

func _on_PickUp_area_entered(area):
	if area.is_in_group("snake"): 
		area.owner.pickup(self)
		Global.emit_signal("enem_eaten")
		self.queue_free()
		$PickUp/CollisionShape2D2.set_deferred("disabled",true)



func split_to_8_dir(dir:Vector2): 
	var dirs = [Vector2.UP, Vector2.DOWN,Vector2.LEFT, Vector2.RIGHT, Vector2(-1,-1),Vector2(-1,1), Vector2(1,-1),Vector2(1,1)]
	dir = dir.normalized()
	var result = dirs[0]
	var min_angle = abs(dir.angle_to(dirs[0]))
	
	for expected_dir in dirs: 
		if abs(dir.angle_to(expected_dir)) < min_angle: 
			result = expected_dir 
			min_angle = abs( dir.angle_to(expected_dir))
	
	return result.normalized()

		
func shoot(): 
#	animp.play("shoot")
#	play_anim("shoot")
	var bullet = preload("res://Ultility/EnemBullet.tscn").instance()
	var dir = split_to_8_dir(global_position.direction_to(p.head_pos))
	var pos = global_position + dir * Global.CELL_SIZE
	bullet.set_dir(dir)
	bullet.damage = damage 
	
	add_child(bullet)
	bullet.global_position = pos 
	

func _on_shoot_timeout():
	if p: 
		shoot()
	if enem_type == EnemTypes.DAME: 
		yield(get_tree().create_timer(.3),"timeout")
		shoot() 
		yield(get_tree().create_timer(.3),"timeout")
		shoot() 
func pick_dir(): 
	var dirs = [Vector2.UP, Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT, Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1),Vector2(1,1)]
	return  dirs[rng.randi()%8] 

func move(): 
	var newpos = global_position+dir*Global.CELL_SIZE
	
	var max_tries = 20
	var tries = 0
	while Global.is_out_border(newpos) and tries <= max_tries: 
		dir = pick_dir() 
		newpos = global_position+dir*Global.CELL_SIZE
		tries+=1
	if tries >= max_tries: 
		print("Stuck")
		return 
	
	
	global_position = newpos
		
func _on_move_timeout():
	$move.wait_time = 1/speed 
	move()

func _on_Hurtbox_receive_damage(hitbox):
	$AnimationPlayer2.play("white_flash")
	HPComp.health -= hitbox.damage 
	Global.emit_signal("enem_hit")
	


func _on_change_dir_timeout():
	dir = pick_dir()
