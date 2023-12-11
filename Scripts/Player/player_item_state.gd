extends State
class_name PlayerItemState

var player : Player


func _ready() -> void :
	var above = get_parent()
	await above.ready
	await above.get_parent().ready
	player = above.get_parent()
