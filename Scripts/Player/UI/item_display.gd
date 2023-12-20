extends PanelContainer

signal slot_clicked(index: int, button: int)

var itemref : ItemRef = null

@onready var texture_rect : TextureRect = $MarginContainer/TextureRect
@onready var amount_label : Label = $Amount
#@onready var color_rect = $MarginContainer/ColorRect


#func _ready():
	#if inventory_manager == null:
		#printerr("No inventory manager on this item display")
	#else:
		#inventory_manager.inventory_changed.connect(update_contents)
		#update_contents()


func set_slotref(slotref : SlotRef, is_grabbed := false) -> void :
	var itemref := slotref.itemref
	texture_rect.texture = itemref.image
	if not is_grabbed:
		tooltip_text = itemref.name + "\n" + itemref.description
	else:
		tooltip_text = ""

	if slotref.amount > 1:
		amount_label.visible = true
		amount_label.text = str("x", slotref.amount)
	else:
		amount_label.visible = false


#func update_contents():
	#var manager_itemref : ItemRef = inventory_manager.inventory[id]
	#if itemref == manager_itemref: return
	#itemref = manager_itemref
	#texture_rect.texture = itemref.image
	#texture_rect.tooltip_text = itemref.name


#func set_active(index : int) -> void :
	#color_rect.visible = get_index() == index


func _on_gui_input(event):
	if (event is InputEventMouseButton
		and (event.button_index == MOUSE_BUTTON_LEFT
		or event.button_index == MOUSE_BUTTON_RIGHT)
		and event.is_pressed()):
		slot_clicked.emit(get_index(), event.button_index)
