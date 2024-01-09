extends CanvasLayer

onready var announcelabel = $WaveAnnounce
func get_score(): 
	return int($Score.text)
func set_score(val: int ): 
	$Score.text = str(val)

func show_announce(val): 
	announcelabel.text = val 
	announcelabel.visible = true 
	
func hide_announce(): 
	announcelabel.visible = false
