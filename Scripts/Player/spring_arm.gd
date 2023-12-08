extends SpringArm3D

@export var mouse_sensitivity := 0.15
@export var analog_sensitivity := 0.75
@export var offset := Vector3.ZERO

var _analog_look := 0.0

@export var target : Node3D


func _process(_delta):
	$Camera3D/Control/FPS.text = str(Engine.get_frames_per_second())
	_analog_look = Input.get_axis("look_left", "look_right")
	rotate_y(deg_to_rad(_analog_look * analog_sensitivity))
	global_position.x = target.global_position.x
	global_position.z = target.global_position.z
	global_position.y = target.global_position.y + offset.y
	#if player.is_on_floor() or absf(player.velocity.y) > player.plat_comp.jump_force * 1.5 or player.plat_comp.explosive_jumping:
	#	global_position.y = player.global_position.y + offset.y


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
