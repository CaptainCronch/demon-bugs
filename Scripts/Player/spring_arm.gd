extends SpringArm3D

var mouse_sensitivity := 0.15
var analog_sensitivity := 0.75
var offset := Vector3.ZERO

var _analog_look := Vector2()

@onready var player : Player =  $".."


func _process(delta):
	$Camera3D/Control/FPS.text = str(Engine.get_frames_per_second())
	_analog_look = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	rotate_y(deg_to_rad(_analog_look.x * analog_sensitivity))
	global_position.x = player.global_position.x + offset.x
	global_position.z = player.global_position.z + offset.z
	global_position.y = player.global_position.y + offset.y
	#if player.is_on_floor() or absf(player.velocity.y) > player.plat_comp.jump_force * 1.5 or player.plat_comp.explosive_jumping:
	#	global_position.y = player.global_position.y + offset.y


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
