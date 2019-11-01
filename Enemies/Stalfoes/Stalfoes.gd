extends Entity

# Timer for movement
var movetimer_length = 15
var movetimer = 0

# Damage
const damage = 1

func _ready() -> void:
	# Play Animation
	$"anim".play("move")
	
	# Start move direction
	move_dir = dir.rand()
	
	# Lighter
	weight = 0.75

func _physics_process(delta):
	# Move
	movement_loop()
	damage_loop()
	
	# Add to timer
	if movetimer <= 15:
		movetimer += 1
	
	# Check if wall was hit
	if is_on_wall() || movetimer >= movetimer_length:
		move_dir = dir.rand()
		movetimer = 0