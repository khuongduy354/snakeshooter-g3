extends Node2D




func _ready():
	var dir = Vector2(1,0)
	print(split(dir))
	print(dir.angle_to(Vector2.RIGHT))
	print(dir.angle_to(Vector2(-1,-1)))
	
func split(dir: Vector2): 
	var dirs = [Vector2.UP, Vector2.DOWN,Vector2.LEFT, Vector2.RIGHT, Vector2(-1,-1),Vector2(-1,1), Vector2(1,-1),Vector2(1,1)]
	dir = dir.normalized()
	var result = dirs[0]
	var min_angle = abs(dir.angle_to(dirs[0]))
	
	for expected_dir in dirs: 
		if dir.angle_to(expected_dir) < min_angle: 
			result = expected_dir 
			min_angle = abs(dir.angle_to(expected_dir))
	
	return result.normalized()
