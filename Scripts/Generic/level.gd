extends Node2D

func _ready() -> void:
	# Update DataBusSingleton - an autoload scene
	DataBusSingleton.current_scene = self
