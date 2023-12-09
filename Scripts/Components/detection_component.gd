extends Area3D
class_name DetectionComponent

signal interest_entered

@export var detection_radius := 10.0
@export var enter_radius := 5.0
@export var resolution := 8
@export var detection_length := 2.0
@export var rotation_target : Node3D
@export var character_body : CharacterBody3D
@export var plat_comp : PlatformerComponent
@export var active := false

var entered_areas : Array[Area3D] = []
var interests : Array[float] = []
var dangers : Array[float] = []
var ray_directions : Array[Vector2] = []
var floor_normal : Vector3
var target_bias := 1

@onready var collider : CollisionShape3D = $CollisionShape3D
@onready var enter_collider : CollisionShape3D = $EnterArea/CollisionShape3D
@onready var rotator = $Rotator
@onready var line = $Rotator/DebugLine


func _ready() -> void :
	collider.shape.radius = detection_radius
	enter_collider.shape.radius = enter_radius
	interests.resize(resolution)
	dangers.resize(resolution)
	ray_directions.resize(resolution)
	for i in resolution:
		var angle = i * 2 * PI / resolution
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

	line.height = detection_length
	line.position.z = -(detection_length/2)


func _physics_process(_delta):
	if not active: return
	set_interest()
	var chosen_dir := Vector2()
	for i in resolution:
		chosen_dir += ray_directions[i] * interests[i]
	chosen_dir = chosen_dir.normalized()
	rotator.rotation.y = atan2(chosen_dir.x, chosen_dir.y) + PI
	plat_comp.move_dir = chosen_dir


func set_interest():
	var this_interest := get_interest()
	for i in resolution:
		var d := ray_directions[i].dot(this_interest)
		interests[i] = maxf(0, d)


func get_interest() -> Vector2 :
	var entities : Array[CharacterBody3D] = []
	var distances : Array[float] = []
	var i := 0
	for area in entered_areas:
		if area is HitboxComponent:
			if area.get_parent().is_in_group("attack_target"):
				entities.append(area.get_parent())
				distances.append(global_position.distance_squared_to(area.get_parent().global_position))
		i += 1
	if entities.size() == 0:
		active = false
		return Vector2()
	var winner := entities[distances.find(distances.max())]
	var win_dir := Global.vec3_to_2(global_position.direction_to(winner.global_position))
	if winner is Player: return win_dir * target_bias
	else: return win_dir * target_bias * 2


func _on_area_entered(area):
	if area is HitboxComponent:
		if area.get_parent() is Player:
			interest_entered.emit()
			entered_areas.append(area)


func _on_area_exited(area):
	if area is HitboxComponent:
		if area.get_parent() is Player:
			entered_areas.erase(area)
