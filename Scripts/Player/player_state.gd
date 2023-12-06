extends State
class_name PlayerState

var player : Player


func _ready():
	var above = get_parent()
	await above.ready
	player = above.get_parent()


func update(_delta):
	pass


func get_interact_input():
	if Input.is_action_pressed("use") and player.holding_item:
		if player.item_holder.get_child(0) is Item:
			transitioned.emit(self, "playerthrow")
		else:
			transitioned.emit(self, "playerhold")
