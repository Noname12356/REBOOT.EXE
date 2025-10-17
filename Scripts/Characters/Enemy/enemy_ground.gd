extends CharacterBody2D

@export var speed: float = 40.0
var move_right = true


@onready var ground_ray_left = %GroundRayLeft
@onready var ground_ray_right = %GroundRayRight
@onready var wall_ray_left = %WallRayLeft
@onready var wall_ray_right = %WallRayRight

@onready var attack_box = %AttackBox

@onready var animator = %Animator
@onready var sprite = %Sprite

@onready var death_sound_player: AudioStreamPlayer = %DeathSoundPlayer

func _ready() -> void:
	animator.play("walk")

func _physics_process(delta):
	# Set the velocity to move in the given direction
	if !wall_ray_left.is_colliding() and !wall_ray_right.is_colliding():
		if !ground_ray_left.is_colliding() or !ground_ray_right.is_colliding():
			if velocity.x >0:
				move_right = false
			else :
				move_right = true
	else:
		if velocity.x >0:
			move_right = false
		else :
			move_right = true

	if move_right:
		velocity.x = 1 * speed
	else :
		velocity.x = -1 * speed

	# Optionally, flip the sprite to face the new direction
	sprite.flip_h = !move_right

	# Move the enemy according to the velocity
	move_and_slide()

func _take_damage():
	# Disable attack box so it can't hurt the player
	attack_box.monitoring = false
	
	death_sound_player.play()
	
	# Blink red
	sprite.modulate = Color(255, 0,0)
	
	# Delay death
	await get_tree().create_timer(0.1).timeout
	
	queue_free()
