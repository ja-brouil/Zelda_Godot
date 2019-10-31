extends Entity

# Sword attack
#var sword_swing = false

# Physics
func _physics_process(delta):
	controls_loop()
	movement_loop()
	set_sprite_direction()
	damage_loop()
	
	# Check if Link has hit a wall for push animation
	# Test if next grid is a wall
	if is_on_wall() && move_dir != dir.center:
		if sprite_dir == "left" and test_move(transform, Vector2(-1,0)):
			animation_switch("push")
		if sprite_dir == "right" and test_move(transform, Vector2(1,0)):
			animation_switch("push")
		if sprite_dir == "up" and test_move(transform, Vector2(0,-1)):
			animation_switch("push")
		if sprite_dir == "down" and test_move(transform, Vector2(0,1)):
			animation_switch("push")
	# Move only if Link is moving
	elif move_dir != Vector2(0,0):
		animation_switch("walk")
	else:
		animation_switch("idle")

# Move Controls
func controls_loop() -> void:
	# Movement
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	# Prevent multiple key pressdowns from having priority over others
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)