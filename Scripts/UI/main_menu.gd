extends Control

@export var level:PackedScene 

@onready var play_button = %ButtonPlay
@onready var button_hover_sound_player = %ButtonHoverSound

func _ready() -> void:
	play_button.grab_focus()


func _on_button_play_button_down() -> void:
	get_tree().change_scene_to_packed(level)

func _on_button_quit_button_down() -> void:
	get_tree().quit()

func _on_button_play_focus_entered() -> void:
	_play_button_sound()

func _on_button_quit_focus_entered() -> void:
	_play_button_sound()

func _play_button_sound():
	button_hover_sound_player.play()
