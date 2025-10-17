extends Control

@onready var retry_button = %ButtonRetry
@onready var button_hover_sound_player = %ButtonHoverSound

func _ready() -> void:
	retry_button.grab_focus()
	get_tree().paused = true

func _on_button_retry_button_down() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_button_quit_button_down() -> void:
	get_tree().quit()

func _on_button_retry_focus_entered() -> void:
	_play_button_sound()

func _on_button_quit_focus_entered() -> void:
	_play_button_sound()

func _play_button_sound():
	button_hover_sound_player.play()
