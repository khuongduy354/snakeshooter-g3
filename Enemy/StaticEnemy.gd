extends Node2D

export var max_health = 1
export var damage = 1
export var die_frame = 43

onready var HPComp = $HealthComp
onready var sprite = $Sprite




func _on_HealthComp_health_changed(val):
	if val <= 0: 
		die()
		
func die(): 
	sprite.frame = die_frame
	$Hurtbox.set_enable(false)
	$PickUp.monitorable = true
	$PickUp.monitoring = true

func _on_PickUp_area_entered(area):
	if area.is_in_group("snake"): 
		area.owner.pickup(self)
		self.queue_free()


func _on_Hurtbox_receive_damaged(hitbox):
	HPComp.health -= hitbox.damage 
