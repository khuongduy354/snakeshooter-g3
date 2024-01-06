extends Node2D

onready var snake = $Snake 
onready var enemies = $Enemies
func _ready(): 
	for enem in enemies.get_children(): 
		enem._initialize_(snake)
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
	if input != Vector2.ZERO and $snaketimer.is_stopped(): 
		snake.move(input) 
		$snaketimer.start()
	if Input.is_action_just_pressed("ui_accept"): 
		snake.shoot()
