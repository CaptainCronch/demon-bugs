extends Resource
class_name ItemRef

#@export var item_scene : PackedScene
@export var ref_id : String
@export var image : CompressedTexture2D
@export var name : String
@export_multiline var description : String
@export var stackable := true
@export var max_stack := 99
@export var tags : PackedStringArray = []


func _init():
	ref_id = self.resource_name
