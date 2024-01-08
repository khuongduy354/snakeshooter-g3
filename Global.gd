extends Node

const CELL_SIZE = 8
const width = 100
const height = 100 

func is_border(pos:Vector2): 
	if pos.x < width * Global.CELL_SIZE and pos.y < height * Global.CELL_SIZE and pos.x >= 0 and pos.y >= 0: 
		return false
	return true
