extends State
class_name CameraState

@export var fov := 50.0
@export var distance := 10.0
@export var angle := -30.0
@export var offset := Vector3(0, 0.8, 0)
@export var up_state : String
@export var down_state : String
@export var transition_time := 0.5

var spring_arm : SpringArm3D
var camera : Camera3D

var tween : Tween


func _ready():
	var above = get_parent()
	await above.ready
	spring_arm = above.get_parent()
	camera = spring_arm.get_node("Camera3D")


func enter():
	#if tween: tween.kill()
	#tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	camera.fov = fov
	#tween.tween_property(camera, "fov", fov, transition_time)
	#tween.tween_property(camera, "h_offset", offset.x, transition_time)
	#tween.tween_property(spring_arm, "spring_length", distance, transition_time)
	#tween.tween_property(spring_arm, "rotation_degrees:x", angle, transition_time)
	#tween.tween_property(spring_arm, "offset:y", offset.y, transition_time)


func update(_delta):
	if Input.is_action_just_pressed("look_up"):
		transitioned.emit(self, up_state)
	elif Input.is_action_just_pressed("look_down"):
		transitioned.emit(self, down_state)
