extends Area3D
class_name DetectionComponent

signal interest_entered

@export var detection_radius := 15.0
@export var enter_radius := 8.0
@export var resolution := 16
@export var detection_length := 5.0
@export var detection_cooldown := 0.2
@export var cooldown_randomness := 0.1
@export var rotation_target : Node3D
@export var character_body : CharacterBody3D
@export var plat_comp : PlatformerComponent
@export var own_hitbox : HitboxComponent
@export var active := false
@export var detection_groups : PackedStringArray = ["player"]
@export_flags_3d_physics var danger_mask := 3

var entered_areas : Array[Area3D] = []
var interests : PackedFloat32Array = []
var dangers : PackedFloat32Array = []
var ray_directions : PackedVector2Array = []
var floor_normal := Vector3.UP
var distance_to_target : float
var chosen_dir := Vector2()

@onready var collider : CollisionShape3D = $CollisionShape3D
@onready var enter_collider : CollisionShape3D = $EnterArea/CollisionShape3D
@onready var cooldown_timer : Timer = $DetectionCooldown

var rotator = preload("res://Scenes/rotator.tscn")
var rotators : Array[Node3D] = []


func _ready() -> void :
	cooldown_timer.start(randfn(detection_cooldown, cooldown_randomness))
	collider.shape.radius = detection_radius
	enter_collider.shape.radius = enter_radius
	interests.resize(resolution)
	dangers.resize(resolution)
	ray_directions.resize(resolution)
	for i in resolution:
		var angle = i * 2 * PI / resolution

		var new_rotator : Node3D = rotator.instantiate()
		add_child(new_rotator)
		new_rotator.get_child(0).height = detection_length
		new_rotator.get_child(0).position.z = -(detection_length/2)
		new_rotator.rotation.y = angle
		rotators.append(new_rotator)
		if i == 0:
			new_rotator.get_child(0).height = detection_length * 2
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _physics_process(_delta):
	if not active: return
	plat_comp.move_dir = chosen_dir


func set_interest():
	var this_interest := get_interest()
	for i in resolution:
		var d := ray_directions[i].dot(this_interest)
		interests[i] = maxf(0, d)


func get_interest() -> Vector2 : # choose target from valid entities in radius
	var entities : Array[CharacterBody3D] = []
	var distances : Array[float] = []
	for area in entered_areas:
		if not area: continue
		entities.append(area.get_parent())
		distances.append(global_position.distance_squared_to(area.get_parent().global_position))
	if entities.size() == 0:
		active = false
		return Vector2()
	var winner := entities[distances.find(distances.min())]
	distance_to_target = global_position.distance_to(winner.global_position)
	return Global.vec3_to_2(global_position.direction_to(winner.global_position))


func set_danger():
	var space_state = get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.collision_mask = danger_mask
	params.exclude = [self, own_hitbox.get_rid()]
	params.from = global_position

	for i in resolution:
		var rotated_dir := Global.vec2_to_3(ray_directions[i]).rotated(Vector3.UP, rotation_target.rotation.y)
		var ray_offset := (rotated_dir - rotated_dir.project(character_body.get_floor_normal())).normalized() * detection_length
		params.to = global_position + ray_offset
		var result := space_state.intersect_ray(params)
		if result:
			dangers[i] = 1.0
			#print(str(global_position.distance_to(result.position) / detection_length))
		else:
			dangers[i] = 0.0
		#Global.line(global_position, global_position + ray_offset, Color.WHITE, 0.1)


func _on_area_entered(area):
	if area is HitboxComponent and area != own_hitbox:
		for group in detection_groups:
			if area.get_parent().is_in_group(group):
				interest_entered.emit()
				if area in entered_areas: return
				entered_areas.append(area)
				return


func _on_area_exited(area):
	if area is HitboxComponent and area != own_hitbox:
		for group in detection_groups:
			if area.get_parent().is_in_group(group):
				entered_areas.erase(area)
				return


func _on_detection_cooldown_timeout():
	cooldown_timer.start(randfn(detection_cooldown, cooldown_randomness))
	if not active: return
	set_interest()
	set_danger()
	chosen_dir = Vector2()
	for i in resolution:
		print(str(interests[i]))
		interests[i] = interests[i] - dangers[i]
		chosen_dir += ray_directions[i] * interests[i]
	chosen_dir = chosen_dir.normalized()
	#Global.line(global_position, global_position + Global.vec2_to_3(chosen_dir * detection_length), Color.WHITE, 0.1)
