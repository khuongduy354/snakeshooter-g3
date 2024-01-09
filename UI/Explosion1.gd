extends Particles2D


func emit(): 
	emitting = true 
	yield(get_tree().create_timer(lifetime),"timeout")
	queue_free()
