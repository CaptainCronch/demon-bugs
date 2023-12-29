extends RigidBody3D
class_name Item

@export var ref_id : String
@export var amount := 1

var grabbable := false
var pick_up_delay := 0.5
var slotref : SlotRef
var timer : Timer


func _ready():
	slotref = SlotRef.new()
	slotref.itemref = Global.tag_to_ref(ref_id)
	if slotref.itemref == null:
		printerr("couldnt find itemref resource")
	if amount:
		slotref.amount = amount

	timer = Timer.new()
	add_child(timer)
	timer.set_owner(self)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	pick_up_timer()


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	var distance_factor := (inverse_lerp(0, radius, global_position.distance_to(origin)) * -0.5) + 1
	if distance_factor < 0.5: return
	var up_pos := Vector3(global_position.x, global_position.y + upthrust, global_position.z)
	linear_velocity += origin.direction_to(up_pos) * distance_factor * power


func pick_up_timer(time := pick_up_delay) -> void :
	grabbable = false
	timer.start(time)


func _on_timer_timeout():
	grabbable = true
