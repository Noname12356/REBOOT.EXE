extends Area2D

@onready var sprite: Sprite2D = %Sprite2D
@onready var pickup_sound_player = %PickupSoundPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		
		# Update DataBusSingleton
		DataBusSingleton.apples_collected += 1
		
		# Disable the collision and visuals for the apple 
		monitoring = false
		sprite.visible = false
		pickup_sound_player.play()
		
		# Wait for a bit so the sound plays fully
		await get_tree().create_timer(0.2).timeout
		
		queue_free()
