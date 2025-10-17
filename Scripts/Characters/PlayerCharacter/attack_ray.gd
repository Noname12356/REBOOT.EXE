extends ShapeCast2D

@onready var character = get_parent()

func _process(delta: float) -> void:
	if get_collider(0):
		if character.velocity.y > 0 and get_collider(0):
			var target = get_collider(0)
			
			# Damage target if it has _take_damage method
			if target.has_method("_take_damage"):
				target._take_damage()
				character.velocity.y = -300
			# Damage target parent if it has _take_damage method
			elif target.get_parent().has_method("_take_damage"):
				target.get_parent()._take_damage()
				character.velocity.y = -300
