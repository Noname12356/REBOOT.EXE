extends Node

@onready var fail_screen = preload("res://Prefabs/UI/fail_screen.tscn")

# Data collected from various scenes
# current_scene is updated from level.gd on _ready()
var current_scene

# player is updated from player.gd on _ready()
var player
# player is updated continously from player.gd
var player_health = 0
# apples_collected is updated when apple is picked up
var apples_collected = 0

func _process(delta: float) -> void:
	
	# Exchange 5 apples for 1 health
	if apples_collected >= 5:
		apples_collected = 0
		player.health += 1

# _spawn_fail_screen is called from player.gd when health goes under 1
func _spawn_fail_screen():
	# Spawns fails screen
	var fail_screen_instance = fail_screen.instantiate()
	current_scene.add_child(fail_screen_instance)
