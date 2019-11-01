extends Node2D

# Type for collision detection
var TYPE = null

# Sword Damage
var damage = 1

# Max Amount
var max_amount = 1

func _ready():
	TYPE = get_parent().TYPE
	get_parent().get_node("Link_Sprite").visible = false
	# Signal for when sword animation is done
	$"anim".connect("animation_finished", self, "finish_swing")
	$"anim".play(str("sword",get_parent().sprite_dir))
	play_sound()
	
	# Set state swing
	if get_parent().has_method("state_swing"):
		get_parent().action_state = "swing"

# End animation
func finish_swing(animation) -> void:
	# Let object finish processing then release
	if get_parent().has_method("state_swing"):
		if Input.is_action_pressed("b button"):
			get_parent().action_state = "sword_out"
		else:
			cleanup_swing()

# Clean ups extra object stuff
func cleanup_swing() -> void:
	get_parent().action_state = "default"
	get_parent().get_node("Link_Sprite").visible = true
	queue_free()

# Play Sword Sound
func play_sound() -> void:
	var random = randi() % 4 + 1
	get_node(str("SwordSound/Sword", random)).play(0)

# Set Spin attack to ready
func set_spin_attack_ready() -> void:
	get_parent().action_state = "spin_attack_ready"