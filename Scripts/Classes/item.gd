extends RigidBody3D
class_name Item

@export var ref_id : String
@export var amount : int

var slotref : SlotRef



func _ready():
	slotref = SlotRef.new()
	slotref.itemref = Global.tag_to_ref(ref_id)
	if slotref.itemref == null:
		printerr("couldnt find itemref resource")
	if amount:
		slotref.amount = amount


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	var distance_factor := (inverse_lerp(0, radius, global_position.distance_to(origin)) * -0.5) + 1
	if distance_factor < 0.5: return
	var up_pos := Vector3(global_position.x, global_position.y + upthrust, global_position.z)
	linear_velocity += origin.direction_to(up_pos) * distance_factor * power
