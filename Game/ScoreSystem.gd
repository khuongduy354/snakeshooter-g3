extends Node2D

signal score_gained

var scores = {
	"eat": 30, 
	"kill": 30, 
	"damage":10,
	"wave_clear":200,
}


func _ready(): 
	Global.connect("enem_eaten",self,"_handler",["eat"])
	Global.connect("enem_killed",self,"_handler",["kill"])
	Global.connect("enem_hit",self,"_handler",["damage"])
	Global.connect("wave_clear",self,"_wave_clear_handler")

func _wave_clear_handler(widx): 
	_handler("wave_clear")

func _handler(key): 
	var score = scores[key]
	emit_signal("score_gained",score)
	
	
