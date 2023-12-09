extends State
class_name BugState

@export var random_spread := 0.5
@export var plat_comp : PlatformerComponent
@export var detect_comp : DetectionComponent

var target : Bug


func _ready() -> void :
	var above : StateMachine = get_parent()
	await above.ready
	target = above.get_parent()
	detect_comp.interest_entered.connect(func(): transitioned.emit(above.current_state, "chase"))
