extends CanvasLayer


func _physics_process(delta): 
	if Input.is_action_just_pressed("ui_accept"): 
		get_tree().change_scene("res://Game/Board.tscn")