extends SpringArm3D

var mouse_sensitivity := 0.15
var analog_sensitivity := 0.75
var camera_offset := Vector3.ZERO

var _analog_look := Vector2()

@onready var player : Player =  $".."


func _process(delta):
	_analog_look = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	global_position = player.global_position + camera_offset
	$Camera3D/Control/FPS.text = str(Engine.get_frames_per_second())


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
