extends Area2D
class_name PowerUp

signal expire

enum PTypes{ 
	INVINC, 
	SPREAD, 
	RAPID
}
export(int,"Invinc","Spread","Rapid") var power_type = 0
export var timeout_duration = 0

onready var sprite = $Sprite
var snake = null 

func _ready(): 
	match power_type: 
		PTypes.INVINC: 
			sprite.frame = 0
			timeout_duration = 10 
		PTypes.SPREAD: 
			sprite.frame = 4 
			timeout_duration = 5
			
		PTypes.RAPID: 
			sprite.frame = 8
			timeout_duration = 5
	$Timer.wait_time = timeout_duration

func say_hi(): 
	pass 
func shoot(): 
	pass
func _power_process(s): 
	if s: 
		snake = s
	if power_type == PTypes.INVINC: 
		for part in s.parts.get_children(): 
			part.set_hurtbox_enable(false)
			part.modulate = Color.red
			
#			s.animp.play("flash")
			# TODO: snake.animp.play("flash") 

func _on_PowerUp_area_entered(area):
	if area.is_in_group("snake"):
		self.monitorable = false 
		self.monitoring = false
		self.visible = false
		area.owner.pickup(self)
		$Timer.wait_time = timeout_duration
		$Timer.start()

func cleanup(): 
	if power_type == PTypes.INVINC and snake != null: 
		if power_type == PTypes.INVINC: 
			for part in snake.parts.get_children(): 
				part.set_hurtbox_enable(true)
				snake.parts.visible = true
				snake.modulate = Color.white
	if power_type == PTypes.RAPID: 
		pass 
	if power_type == PTypes.SPREAD: 
		pass 
		
func _on_Timer_timeout():
	cleanup()
	emit_signal("expire")
	self.queue_free()
	
