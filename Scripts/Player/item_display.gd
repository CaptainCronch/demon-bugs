extends Control

@export var inventory_manager : InventoryManager

var itemref : ItemRef = null
var id := 0

@onready var texture_rect : TextureRect = $MarginContainer/TextureRect
@onready var amount_label : Label = $Amount


func _ready():
	if inventory_manager == null:
		printerr("No inventory manager on this item display")
	else:
		inventory_manager.inventory_changed.connect(update_contents)
		update_contents()


func update_contents():
	var manager_itemref : ItemRef = inventory_manager.inventory[id]
	if itemref == manager_itemref: return
	itemref = manager_itemref
	texture_rect.texture = itemref.image
	texture_rect.tooltip_text = itemref.name

