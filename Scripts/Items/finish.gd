extends Area2D

@export var ending_delay:float = 2
@onready var victory_sound_player = %VictorySound

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_victory()

func _victory():
		
	# Wait for a bit so the sound plays fully
	await get_tree().create_timer(ending_delay).timeout
	
	# Change scene to main menu
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
