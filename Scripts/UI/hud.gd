extends Control

@onready var health_number_label = %HealthNumber
@onready var apples_number_label = %AppleNumber

func _process(delta: float) -> void:
	
	# Update UI based on information from DataBusSingleton
	
	var player_health = DataBusSingleton.player_health
	var apples = DataBusSingleton.apples_collected
	
	health_number_label.text = str(player_health)
	apples_number_label.text = str(apples)
