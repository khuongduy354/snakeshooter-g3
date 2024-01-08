extends Node2D
class_name Board 

onready var snake = $Snake 
onready var enemies = $Enemies
onready var WaveSpawner = $WaveSpawner 

func spawn_mob(em:Enemy): 
	em._initialize_(snake)
	enemies.add_child(em)
	
func _ready(): 
	WaveSpawner._initialize_(self)
	WaveSpawner.start_next_wave()

	

func get_input(): 
	var input = Vector2.ZERO 
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	elif Input.is_action_pressed("ui_left"):
		input.x -= 1
	elif Input.is_action_pressed("ui_down"):
		input.y += 1
	elif Input.is_action_pressed("ui_up"):
		input.y -= 1
	return input.normalized()
	
func _physics_process(delta): 
	var input = get_input() 
	if snake.powerup != null: 
		snake.powerup._power_process(snake)
	move_snake(input) 

	if Input.is_action_just_pressed("ui_accept"): 
		snake.shoot()
func move_snake(input: Vector2): 
	if input == Vector2.ZERO: 
		input = snake.facing_dir
	if $snaketimer.is_stopped(): 
		snake.move(input) 
		$snaketimer.start()
