extends Node

const CELL_SIZE = 8
const width = 1024 / 2 /  CELL_SIZE 
const height =  600 / 2 / CELL_SIZE 

func is_out_border(pos:Vector2): 
	if pos.x < width * Global.CELL_SIZE and pos.y < height * Global.CELL_SIZE and pos.x >= 0 and pos.y >= 0: 
		return false
	return true

func pick_on_percent(percent): 
	if percent >= randi()%100+1: 
		return true 
	return false    
