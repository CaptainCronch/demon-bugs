extends Tool

@export var area : Area3D


func swing(on : bool) -> void :
	area.monitorable = on
	area.monitoring = on


func _on_area_entered(area):
	pass # Replace with function body.
