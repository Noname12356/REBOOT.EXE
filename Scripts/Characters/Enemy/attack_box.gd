extends Area2D

@onready var character = get_parent()
var damage = 1

func _on_area_entered(target: Area2D) -> void:
	
	# Damage target area if it has _take_damage method
	if target.has_method("_take_damage"):
		target._take_damage(damage)
		character._take_damage()

	# Damage target area parent if it has _take_damage method
	if target.get_parent().has_method("_take_damage"):
		target.get_parent()._take_damage(damage)
		character._take_damage()
