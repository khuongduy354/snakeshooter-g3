extends Node2D
class_name WaveSpawner 

signal wave_changed
signal wave_clear

export var max_waves = 20
export var spawn_wait_time_range = Vector2(2.0,5.0)
export var wave_spawn_range = Vector2(2,4)

var curr_wave = 0
var curr_wave_mobs_mcount = 0
var curr_wave_mobs_count = 0
var mobs_death = 0 

var rng = RandomNumberGenerator.new() 
var b: Board = null
export var types_percentage = { 
	Enemy.EnemTypes.DAME: 20,
	Enemy.EnemTypes.LIGHT: 50, 
	Enemy.EnemTypes.TANK: 30,
}
# types percentage 
# difficulties factor: mobs stats buff, mobs quans, snake speed, spawn continuality

# curr_wave_mobs_count = wave * 1.5 + randi()%wave + 3

func _initialize_(_b: Board): 
	b = _b
func _ready(): 
	rng.randomize()
	
func pick_mob(): 
	var type = null 
	while type == null: 
		var key_idx = rng.randi()%types_percentage.size()
		var key = types_percentage.keys()[key_idx]
		if Global.pick_on_percent(types_percentage[key]): 
			type = key
	
	var enem = preload("res://Enemy/Enemy.tscn").instance()
	enem.enem_type = type
	
	return enem

func pick_border_pos(): 
	var x = rng.randi()%Global.width + Global.CELL_SIZE/2 
	var y = rng.randi()%Global.height + Global.CELL_SIZE/2 
	
	var modified_x = rng.randi()%2
	if modified_x == 1:
		x = [0,Global.width*Global.CELL_SIZE][rng.randi()%2]
	else: 
		y = [0,Global.height*Global.CELL_SIZE][rng.randi()%2]
	return Vector2(x,y)
func spawn_mob(): 

	
	var pos = pick_border_pos() 
	var mob = pick_mob()
	b.spawn_mob(mob)
	mob.connect("die",self,"_on_mob_die")
	mob.global_position = pos 
	curr_wave_mobs_count += 1 
	
func _on_mob_die(): 
	print(mobs_death)
	if mobs_death < curr_wave_mobs_mcount: 
		mobs_death += 1
	if mobs_death == curr_wave_mobs_mcount: 
		emit_signal("wave_clear",curr_wave)
		Global.emit_signal("wave_clear",curr_wave)

func spawn_mobs(): 
	var to_spawn_count = rng.randi_range(wave_spawn_range.x, wave_spawn_range.y)
	var count = 0 
	while count < to_spawn_count and curr_wave_mobs_count < curr_wave_mobs_mcount: 
		spawn_mob() 
		count+=1

	
func update_wave_stats(): 
	curr_wave_mobs_mcount = int(round( curr_wave * 3 + rng.randi()%curr_wave + 5 ))
	curr_wave_mobs_count = 0 
	mobs_death = 0 
	

func start_next_wave(): 
	if curr_wave > max_waves: 
		print("You winned!")
		return 
	curr_wave += 1 
	print("Current wave: ", curr_wave)
	emit_signal("wave_changed",curr_wave)
	update_wave_stats() 
	_on_spawn_timeout()
	
	


func _on_spawn_timeout():
	if curr_wave_mobs_count < curr_wave_mobs_mcount: 
		spawn_mobs()
		$spawn.wait_time = rand_range(spawn_wait_time_range.x,spawn_wait_time_range.y)
		$spawn.start()
