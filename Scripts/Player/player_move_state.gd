extends State
class_name PlayerMoveState

var player : Player


func _ready():
	var above = get_parent()
	await above.ready
	player = above.get_parent()
