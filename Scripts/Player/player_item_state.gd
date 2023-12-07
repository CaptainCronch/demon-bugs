extends State
class_name PlayerItemState

var player : Player


func _ready() -> void :
	var above = get_parent()
	await above.ready
	player = above.get_parent()


func update(_delta) -> void :
	pass
