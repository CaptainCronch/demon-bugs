extends Control
class_name UI

@export var inv_slide_duration := 0.2

@onready var inventory_panel = $InventoryPanel
@onready var open_pos : Control = $OpenPos
@onready var closed_pos : Control = $ClosedPos
@onready var grabbed_slot = $GrabbedSlot

var grabbed_slotref: SlotRef
var inv_open := false
var tween : Tween


func _ready():
	inventory_panel.set_deferred("position", closed_pos.position)


func _process(_delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() - grabbed_slot.size - Vector2(5, 5)


func slide_inventory() -> void :
	if tween: tween.kill()
	var change_pos : Vector2 = closed_pos.position if inv_open else open_pos.position
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(inventory_panel, "position", change_pos, inv_slide_duration)
	inv_open = !inv_open


func set_inventory_data(invref : InventoryRef) -> void:
	invref.inventory_interact.connect(_on_inventory_interact)
	inventory_panel.set_inventory_data(invref)


func _on_inventory_interact(invref : InventoryRef, index : int, button : int) -> void :
	match [grabbed_slotref, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slotref = invref.grab_slotref(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slotref = invref.drop_slotref(grabbed_slotref, index)
		[null, MOUSE_BUTTON_RIGHT]:
			grabbed_slotref = invref.grab_half_slotref(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slotref = invref.drop_single_slotref(grabbed_slotref, index)

	update_grabbed_slot()


func update_grabbed_slot() -> void :
	if grabbed_slotref:
		grabbed_slot.visible = true
		grabbed_slot.set_slotref(grabbed_slotref, true)
	else:
		grabbed_slot.visible = false
