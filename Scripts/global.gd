extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_window().mode = Window.MODE_FULLSCREEN


func _process(_delta):
	if Input.is_action_just_pressed("debug_key"):
		if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.max_fps = 0
		elif DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Engine.max_fps = 60

	if Input.is_action_just_pressed("escape"):
		get_tree().quit() # temporary for testing

	if Input.is_action_just_pressed("fullscreen"):
		if get_window().mode != Window.MODE_FULLSCREEN:
			get_window().mode = Window.MODE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED


func mouse_switch(pos := Vector2(0, 0)) -> void :
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_window().warp_mouse(pos)
	elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


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


func vec3_to_2(input : Vector3) -> Vector2:
	return Vector2(input.x, input.z)


func vec2_to_3(input : Vector2, add_y := 0.0) -> Vector3:
	return Vector3(input.x, add_y, input.y)


func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	get_tree().get_root().add_child(mesh_instance)
	if persist_ms:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance


func tag_to_item(tag : String) -> PackedScene:
	return load("res://Scenes/Items/" + tag + ".tscn")


func tag_to_ref(tag : String) -> ItemRef:
	return load("res://Resources/" + tag + ".tres")


func spawn_item(slotref : SlotRef,
		pos : Vector3,
		rotation := Vector3(),
		velocity := Vector3(),
		torque := Vector3()) -> void :

	var item : Item = tag_to_item(slotref.itemref.ref_id).instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = pos
	item.angular_velocity = torque
	item.linear_velocity = velocity
	item.rotation = rotation
	item.slotref = slotref


func spawn_item_pop(slotref : SlotRef,
		pos : Vector3,
		torque := 0.0,
		force := 0.0,
		directional := Vector3(),
		rand_factor := 1.0) -> void :
	if not is_instance_valid(slotref): return

	var rand := Vector3(randf_range(-rand_factor, rand_factor),
			randf_range(-rand_factor, rand_factor),
			randf_range(-rand_factor, rand_factor))

	var item : Item = tag_to_item(slotref.itemref.ref_id).instantiate()
	get_tree().current_scene.add_child(item)
	item.global_position = pos
	item.angular_velocity = rand * torque
	item.linear_velocity = rand * force if not directional else directional * (force * randf_range(0, rand_factor))
	item.slotref = slotref
