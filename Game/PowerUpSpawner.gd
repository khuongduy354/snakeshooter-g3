extends Node2D
class_name PowerUpSpawner 

signal wave_changed

export var spawn_interval = 5.0
export var spawn_chance = 60

var curr_wave = 0
var curr_wave_power_mcount = 3
var curr_wave_power_count = 0

var rng = RandomNumberGenerator.new() 
var b: Board = null
export var types_percentage = { 
	PowerUp.PTypes.INVINC: 20,
	PowerUp.PTypes.RAPID: 50,
	PowerUp.PTypes.SPREAD: 30
}
# types percentage 
# difficulties factor: mobs stats buff, mobs quans, snake speed, spawn continuality

# curr_wave_mobs_count = wave * 1.5 + randi()% wave + 5

func _initialize_(_b: Board): 
	b = _b
	
func start(): 
	$spawn.start()

func reset(): 
	curr_wave_power_count = 0 
	$spawn.stop() 
	
func _ready(): 
	rng.randomize()
	$spawn.wait_time = spawn_interval
	
func pick_pow(): 
	var type = null 
	while type == null: 
		var key_idx = rng.randi()%types_percentage.size()
		var key = types_percentage.keys()[key_idx]
		if Global.pick_on_percent(types_percentage[key]): 
			type = key
	
	var powerup = preload("res://Snake/PowerUp/PowerUp.tscn").instance()
	powerup.power_type = type
	
	return powerup

func pick_pos(): 
	var x = rng.randi()%Global.width + 5/2 
	var y = rng.randi()%Global.height + 5/2
	return Vector2(x,y) * Global.CELL_SIZE
	
func spawn_powerup(): 
	var pos = pick_pos() 
	var powerup = pick_pow()
	b.spawn_power(powerup)
	powerup.global_position = pos 
	curr_wave_power_count += 1 
	


func _on_spawn_timeout():
	if curr_wave_power_count < curr_wave_power_mcount and Global.pick_on_percent(spawn_chance): 
		spawn_powerup()
		$spawn.start()
	else: 
		print("maxed power reached")
