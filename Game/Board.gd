extends Node2D
class_name Board 

export var init_wait_time = 0.1 

onready var snake = $Snake 
onready var enemies = $Enemies
onready var powerups = $PowerUps
onready var WaveSpawner = $WaveSpawner 

func spawn_mob(em:Enemy): 
	em._initialize_(snake)
	enemies.add_child(em)
	
func spawn_power(p: PowerUp): 
	powerups.add_child(p)

func adjust_snake_speed(): 
	var widx = WaveSpawner.curr_wave
	var mul = 1 + widx * 5/100
	$snaketimer.wait_time = init_wait_time * mul
	
func _on_snake_die(): 
	Sound.play("gameover")
	$GameUI.show_announce("Game Over!")
	get_tree().paused = true 
	yield(get_tree().create_timer(3),"timeout")
	get_tree().paused = false 
	get_tree().change_scene("res://UI/GameOver.tscn")
	
func _ready(): 
	Sound.play("theme")
	snake.connect("die",self,"_on_snake_die")
	WaveSpawner._initialize_(self)
	$PowerUpSpawner._initialize_(self)
	WaveSpawner.start_next_wave()
	$PowerUpSpawner.start()
	$ScoreSystem.connect("score_gained",self,"_score_gained_handler")
	WaveSpawner.connect("wave_changed",self,"_adjust_snake_speed")
	WaveSpawner.connect("wave_clear",self,"_on_wave_cleared")
	
func _on_wave_cleared(widx): 
	if widx < WaveSpawner.max_waves:
		Sound.play("wave_clear")
		$GameUI.show_announce("Wave Clear!")
		$PowerUpSpawner.reset(WaveSpawner.curr_wave+1) 
		yield(get_tree().create_timer(3),"timeout")
		$GameUI.show_announce("Wave Start!")
		WaveSpawner.start_next_wave()
		yield(get_tree().create_timer(3),"timeout")
		$GameUI.hide_announce()
		$PowerUpSpawner.start() 
	else: 
		get_tree().change_scene("res://UI/GameWin.tscn")
func _score_gained_handler(add_score): 
	$GameUI.set_score($GameUI.get_score()+add_score)
	apply_score_effect(add_score)
	
func apply_score_effect(val): 
	var effect = preload("res://UI/Effects.tscn").instance()
	$Effects.add_child(effect)
	effect.global_position = $effect_pos.global_position
	effect.play_pop_score(val)

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
	if input == Vector2.ZERO or input == -snake.facing_dir: 
		input = snake.facing_dir
	if $snaketimer.is_stopped(): 
		snake.move(input) 
		$snaketimer.start()
