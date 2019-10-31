extends Entity

# Sword attack
var link_state = "idle"

# Physics
func _physics_process(delta):
	controls_loop()
	movement_loop()
	set_sprite_direction()
	damage_loop()
	
	if link_state == "sword":
		$Link_Sprite.visible = false
		$Link_Swing.visible = true
		animation_switch(link_state)
		link_state == "awaiting_end"
		return
	
	if link_state == "awaiting_end":
		if !$Link_Anim.is_playing():
			$Link_Sprite.visible = true
			$Link_Swing.visible = false
			link_state = "idle"
		else:
			return
	
	# Check if Link has hit a wall for push animation
	# Test if next grid is a wall
	if is_on_wall() && move_dir != dir.center:
		link_state = "push"
		if sprite_dir == "left" and test_move(transform, Vector2(-1,0)):
			animation_switch(link_state)
		if sprite_dir == "right" and test_move(transform, Vector2(1,0)):
			animation_switch(link_state)
		if sprite_dir == "up" and test_move(transform, Vector2(0,-1)):
			animation_switch(link_state)
		if sprite_dir == "down" and test_move(transform, Vector2(0,1)):
			animation_switch(link_state)
	# Move only if Link is moving
	elif move_dir != Vector2(0,0):
		link_state = "walk"
		animation_switch(link_state)
	else:
		link_state = "idle"
		animation_switch(link_state)

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
	
	# Set to attack state
	if Input.is_action_just_pressed("b button"):
		link_state = "sword"

# Attack
