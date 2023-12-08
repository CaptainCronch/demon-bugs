extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	if Input.is_action_just_pressed("mouse_escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("debug_key"):
		if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		elif DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	
	if Input.is_action_just_pressed("escape"):
		get_tree().quit() # temporary for testing
	
	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode != Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED


func decay_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :
	
	var new_value := (value - target) * pow(2, -delta * decay_power) + target
	
	if absf(new_value - target) < round_threshold:
		return target
	else:
		return new_value


func decay_angle_towards(value : float, target : float,
			decay_power : float, delta : float = get_process_delta_time(),
			round_threshold : float = 0.0) -> float :
	
	var new_value := angle_difference(target, value) * pow(2, -delta * decay_power) + target
	
	if absf(angle_difference(target, new_value)) < round_threshold:
		return target
	else:
		return new_value
