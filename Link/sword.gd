extends Node2D

onready var anim = $AnimationPlayer

func start():
	if get_parent().is_network_master():
		anim.connect("animation_finished", self, "destroy")
		if get_parent().has_method("state_swing"):
			get_parent().state = "swing"
	anim.play(str("swing", get_parent().spritedir))

func destroy(animation):
	if input != null && Input.is_action_pressed(input):
		set_physics_process(true)
		match get_parent().spritedir:
			"Left":
				position.x += 3
			"Right":
				position.x -= 3
			"Up":
				position.y += 4
				z_index -= 1
			"Down":
				position.y -= 3
		for peer in network.map_peers:
			rpc_id(peer, "set_pos", position)
		return
	
	for peer in network.map_peers:
		rpc_id(peer, "delete")
	delete()

remote func set_pos(p_pos):
	position = p_pos

sync func delete():
	get_parent().state = "default"
	queue_free()

func _physics_process(delta):
	delete_on_hit = true
	if get_parent().has_method("state_hold"):
		get_parent().state = "hold"
	if !Input.is_action_pressed(input):
		destroy(null)
