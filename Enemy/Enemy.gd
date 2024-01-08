extends Node2D
class_name Enemy

enum EnemTypes{ 
	LIGHT, DAME, TANK
}
export(int,"LIGHT","DAME","TANK") var enem_type = EnemTypes.LIGHT
export var max_health = 1
export var die_frame = 43
export var speed = 3
export var damage = 1 
export var max_distance = 3 

onready var HPComp = $HealthComp
onready var sprite = $Sprite
var p: Snake = null
var rng = RandomNumberGenerator.new() 

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

func _ready():
	rng.randomize()
	load_stat()

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
	bullet.damage = damage 
	
	add_child(bullet)
	bullet.global_position = pos 

func _on_shoot_timeout():
	if p: 
		shoot()

func move(): 
	var dirs = [Vector2.UP, Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT, Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1),Vector2(1,1)]
	var dir = dirs[rng.randi()%8]
	var distance = randi()%max_distance+1
	
	while distance >=1: 
		global_position+= dir * Global.CELL_SIZE
		distance-=1
func _on_move_timeout():
	$move.wait_time = 1.0/speed 
	move()
