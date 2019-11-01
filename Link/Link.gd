extends Entity

# Link State
var link_state = "idle"
var action_state = "default"

# Sword Charge Timer
var sword_timer = 0
var second_timer = 0

# Physics
func _physics_process(delta):
	match action_state:
		"default":
			state_defaut()
		"swing":
			state_swing()
		"sword_out":
			spin_out(delta)
		"charging":
			charge_wait(delta)
		"spin_attack_ready":
			spin_attack_ready()
		"spin_attack_state":
			state_defaut()

# State Default
func state_defaut() -> void:
	controls_loop()
	movement_loop()
	set_sprite_direction()
	damage_loop()
	
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
	
	# Sword Attack for now
	if Input.is_action_just_pressed("b button"):
		use_item(preload("res://Items/Sword.tscn"))
	

# Activate while sword is swinging
func state_swing() -> void:
	movement_loop()
	damage_loop()
	move_dir = dir.center

# Hold the sword out for 1 second, play sound then spin attack
func spin_out(delta) -> void:
	controls_loop()
	movement_loop()
	damage_loop()
	sword_timer += delta
	if !Input.is_action_pressed("b button") && sword_timer < 1:
		$Link_Sprite.visible = true
		get_node("Sword").queue_free()
		action_state = "default"
	elif sword_timer > 1:
		# Play sounds for sword charging
		get_node("Sword/SwordSound/SwordCharge").play(0)
		action_state = "charging"
		sword_timer = 0

# Spin charge
func charge_wait(delta) -> void:
	second_timer += delta
	
	controls_loop()
	movement_loop()
	damage_loop()
	# Release too early
	if !Input.is_action_pressed("b button"):
		get_node("Sword/SwordSound/SwordCharge").stop()
		$Link_Sprite.visible = true
		get_node("Sword").queue_free()
		action_state = "default"
	
	if second_timer >= 0.2:
		action_state = "spin_attack_ready"

# Spin Attack
func spin_attack_ready() -> void:
	controls_loop()
	movement_loop()
	damage_loop()
	if Input.is_action_just_released("b button"):
		get_node("Sword/SwordSound/SwordCharge").stop()
		get_node("Sword/anim").play(str("spin",sprite_dir))
		get_node("Sword/SwordSound/SwordSpin").play(0)
		get_node("Sword/anim").connect("animation_finished", self, "spin_attack_done")

func spin_attack_done(animation_name) -> void:
	get_node("Sword").cleanup_swing()

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


# Use Item
func use_item(item):
	# Instance the item and add to group
	var newItem = item.instance()
	newItem.add_to_group(str(newItem.get_name(), self))
	add_child(newItem)
	
	# Make sure maximum isn't more
	if get_tree().get_nodes_in_group(str(newItem.get_name(), self)).size() > newItem.max_amount:
		# Prevent max amount
		newItem.queue_free()