extends CanvasLayer

func get_score(): 
	return int($Score.text)
func set_score(val: int ): 
	$Score.text = str(val)
