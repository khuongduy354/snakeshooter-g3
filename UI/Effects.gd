 extends Node2D


onready var animp = $Effects
onready var scorelabel = $Score
func play_pop_score(val): 
	scorelabel.text = "+" + str(val)
	animp.play("pop_score")


func _on_Effects_animation_finished(anim_name):
	queue_free()
