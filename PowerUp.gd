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

func _ready(): 
	match power_type: 
		PTypes.INVINC: 
			sprite.frame = 0
			timeout_duration = 3
		PTypes.SPREAD: 
			sprite.frame = 4 
			timeout_duration = 3
			
		PTypes.RAPID: 
			sprite.frame = 8
			timeout_duration = 5

func say_hi(): 
	pass 
func shoot(): 
	pass
func apply(): 
	match power_type: 
		PTypes.INVINC: 
			pass
		PTypes.SPREAD: 
			pass
		PTypes.RAPID: 
			pass

func _on_PowerUp_area_entered(area):
	if area.is_in_group("snake"):
		self.monitorable = false 
		self.monitoring = false
		self.visible = false
		area.owner.pickup(self)
		$Timer.wait_time = timeout_duration
		$Timer.start()


func _on_Timer_timeout():
	emit_signal("expire")
	self.queue_free()
	
