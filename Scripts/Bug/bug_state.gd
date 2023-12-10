extends State
class_name BugState

@export var random_spread := 0.5
@export var plat_comp : PlatformerComponent
@export var detect_comp : DetectionComponent

var target : Bug


func _ready() -> void :
	state_machine = get_parent()
	await state_machine.ready
	target = state_machine.get_parent()
