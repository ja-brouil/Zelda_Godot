extends Camera2D

# Activate Enemies when Camera comes into focus
func _ready():
	$Area2D.connect("body_entered", self, "body_entered")
	$Area2D.connect("body_exited", self, "body_exited")

func _process(delta) -> void:
	# Get Link's position
	var pos = get_node("../Link").global_position - Vector2(0,16)
	var x = floor(pos.x / 160) * 160
	var y = floor(pos.y / 128) * 128
	
	# Set Camera to Link's Position
	global_position = lerp(global_position, Vector2(x,y), 0.08) # Smooth Transition
	
func body_entered(body) -> void:
	# Activate enemies who come into the area
	if body.get("TYPE") == "Enemy":
		body.set_physics_process(true)

func body_exited(body) -> void:
	# Deactivate enemies who come into the area
	if body.get("TYPE") == "Enemy":
		body.set_physics_process(false)