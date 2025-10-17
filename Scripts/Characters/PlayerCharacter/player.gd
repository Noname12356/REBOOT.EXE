extends CharacterBody2D

# === Stat Settings ===
@export var health = 3

# === Movement Settings ===
@export var speed: float = 100.0
@export var jump_velocity: float = -300.0
@export var gravity: float = 1200.0
@export var max_fall_speed: float = 1200.0

# === Jump Features ===
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.15

# === Double Jump ===
@export var allow_double_jump: bool = true
@export var max_jumps: int = 2  # 1 = normal jump only, 2 = double jump, etc.
var jumps_left: int = 0

# === Animation Lock ===
@export var landing_animation_duration: float = 0.1

# === Internal Timers ===
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var jump_cutoff_timer: float = 0.0
var landing_lock_timer: float = 0.0

var was_on_floor: bool = false

# === Nodes ===
@onready var sprite: Sprite2D = %MainSprite
@onready var animator: AnimationPlayer = %Animator
@onready var attack_ray: ShapeCast2D = %AttackRay

@onready var jump_audio_player: AudioStreamPlayer = %JumpSound
@onready var hurt_audio_player: AudioStreamPlayer = %HurtSound

func _ready() -> void:
	DataBusSingleton.player = self

func _physics_process(delta):
	# === Handle Timers ===
	_update_timers(delta)

	# === Handle Input ===
	var direction = Input.get_axis("move_left", "move_right")
	var is_jumping = Input.is_action_just_pressed("jump")
	var holding_jump = Input.is_action_pressed("jump")

	# === Horizontal Movement ===
	velocity.x = direction * speed

	# === Jump Logic ===
	_process_jump(is_jumping, holding_jump)

	# === Apply Gravity ===
	_apply_gravity(delta)

	# === Movement ===
	move_and_slide()

	# === Landing Detection ===
	_check_landing()

	# === Sprite Orientation ===
	_flip_sprite()

	# === Play Animations ===
	_play_animations(direction)
	
	# === Update Data Bus ===
	_update_data_bus()
	
	# === Debug ===
	_debug(true) # Change to false to disable

# --------------------------
# === HELPER FUNCTIONS ===
# --------------------------

func _update_timers(delta):
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
		jump_audio_player.play()
	else:
		jump_buffer_timer -= delta

	jump_cutoff_timer = max(jump_cutoff_timer - delta, 0.0)
	landing_lock_timer = max(landing_lock_timer - delta, 0.0)

func _process_jump(is_jumping: bool, holding_jump: bool):
	if is_jumping:
		# Ground or coyote jump
		if (coyote_timer > 0.0 or is_on_floor()) and jumps_left > 0:
			velocity.y = jump_velocity
			jump_buffer_timer = 0.0
			coyote_timer = 0.0
			jump_cutoff_timer = 0.0
			jumps_left -= 1
		# Mid-air jump (double jump)
		elif allow_double_jump and jumps_left > 0:
			velocity.y = jump_velocity
			jumps_left -= 1
			jump_cutoff_timer = 0.0
			jump_buffer_timer = 0.0

	# Variable Jump Height (cutoff when button released early)
	if jump_cutoff_timer <= 0.0 and not holding_jump and velocity.y < 0:
		velocity.y *= 0.5

func _apply_gravity(delta):
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

func _check_landing():
	var just_landed = not was_on_floor and is_on_floor()
	was_on_floor = is_on_floor()

	if just_landed:
		landing_lock_timer = landing_animation_duration
		animator.play("land")
		jumps_left = max_jumps  # Reset jumps on landing

	# Also reset on floor contact in general
	if is_on_floor():
		jumps_left = max_jumps

func _flip_sprite():
	if velocity.x < -1:
		sprite.flip_h = true
	elif velocity.x > 1:
		sprite.flip_h = false

func _play_animations(direction):
	if landing_lock_timer > 0.0:
		return

	if not is_on_floor():
		animator.play("jump")
	elif abs(velocity.x) > 1:
		animator.play("run")
	else:
		animator.play("idle")
	
	# Change animation speed based on movement speed for the run animation
	# so it doesn't animate at full speed when walking slowly
	if animator.current_animation == "run":
		animator.speed_scale = abs(direction)
	else:
		animator.speed_scale = 1.0

func _update_data_bus():
	# Updates DataBusSingleton - an autoload scene for transfering data between scenes
	DataBusSingleton.player_health = health

func _debug(enabled):
	# If enabled prints out various metrics
	if enabled:
		print("Health: ", health)
		print("Velocity X and Y: ", velocity)
		print("Jumps Left: ", jumps_left)

func _take_damage(damage):
	# Function activated from other nodes
	health -= damage
	
	# Change sprite color to solid red and play hurt sound
	sprite.modulate = Color(255, 0, 0, 255)
	hurt_audio_player.play()
	
	# If health is lower than 1 - die
	if health < 1:
		DataBusSingleton._spawn_fail_screen()
	
	# Wait a bit for color to reset
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)
