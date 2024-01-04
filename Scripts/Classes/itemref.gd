extends Resource
class_name ItemRef

@export var ref_id : String
@export var image : CompressedTexture2D
@export var name : String
@export_multiline var description : String
@export var stackable := true
@export var max_stack := 99
@export var tags : PackedStringArray = []
@export var modifier_scene : PackedScene


func _init():
	ref_id = self.resource_name
