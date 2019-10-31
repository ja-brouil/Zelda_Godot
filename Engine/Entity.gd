

extends KinematicBody2D
class_name Entity

# Entity Constants
export(int) var SPEED = 100

# Move Direction
export(Vector2) var move_dir = Vector2(0,0)

#  Hit Stun
var hit_stun = 0

# Knockback direction
export(Vector2) var knock_dir = Vector2(0,0)

# Health
export(int) var health = 1

# Type
export(String) var TYPE = "Enemy"

# Sprite Direction
export(String) var sprite_dir = "down"

func _ready() -> void:
	# Prevent Enemies from coming into the scene if not active
	if TYPE == "Enemy":
		set_physics_process(false)
		# Set Collision Mask
		set_collision_mask_bit(1,1)

# Process Entity Movement
func movement_loop() -> void:
	# Set Knockback
	var motion
	if hit_stun == 0:
		motion = move_dir.normalized() * SPEED
	else:
		motion = knock_dir.normalized() * SPEED * 1.25 # Bit faster when being knocked back
	
	# Consider all walls
	move_and_slide(motion, Vector2(0,0)) 

# Get direction of sprite
func set_sprite_direction() -> void:
	match move_dir:
		Vector2(-1,0):
			sprite_dir = "left"
		Vector2(1,0):
			sprite_dir = "right"
		Vector2(0,-1):
			sprite_dir = "up"
		Vector2(0,1):
			sprite_dir = "down"

# Set Animation of sprite
func animation_switch(animation) -> void:
	var new_animation = str(animation, sprite_dir)
	if $Link_Anim.current_animation != new_animation:
		$Link_Anim.play(new_animation)

# Damage loop
func damage_loop() -> void:
	# Reduce time in hitstun
	if hit_stun > 0:
		hit_stun -= 1
	
	# Get every hitbox and process
	for body in $hit_box.get_overlapping_bodies():
		# Check if not in hitstun, check if type is not player/enemy and check how much damage should be taken
		if hit_stun == 0 and body.get("damage") != null && body.get("TYPE") != TYPE:
			health -= body.get("damage")
			hit_stun = 10
			knock_dir = transform.origin - body.transform.origin