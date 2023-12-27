extends Control
class_name UI

signal active_slot_changed(index : int)

@export var player : Player
@export var inv_slide_duration := 0.2
@export var open_pos := Vector2(1392, 668)
@export var closed_pos := Vector2(1392, 972)
@export var external_open_pos := Vector2(1392, 0)
@export var external_closed_pos := Vector2(1392, -312)

@onready var inventory_panel : InventoryPanel = $InventoryPanel
@onready var grabbed_slot = $GrabbedSlot
@onready var external_inventory = $ExternalInventory
@onready var active_selector = $ActiveSelector


var active_slot := 0
var last_mouse_pos := Vector2()
var grabbed_slotref: SlotRef
var inv_open := false
var slide_tween : Tween
var hotbar_tween : Tween


func _ready():
	active_selector.position.x = inventory_panel.position.x + (100 * active_slot) + 8
	active_selector.position.y = inventory_panel.position.y + 8

	last_mouse_pos = get_window().size / 2
	inventory_panel.set_deferred("position", closed_pos)
	external_inventory.set_deferred("position", external_closed_pos)


func _process(_delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() - grabbed_slot.size - Vector2(5, 5)
	active_selector.position.y = inventory_panel.position.y + 8


func slide_inventory() -> void :
	Global.mouse_switch(open_pos)

	if inv_open and is_instance_valid(grabbed_slotref): # put away grabbed slotref on inv close
		var result := player.inventory.add_slotref(grabbed_slotref) # if no room then drop
		grabbed_slotref = null
		update_grabbed_slot()
		if result != null:
			Global.spawn_item_pop(result, player.global_position, player.throw_force)


	if slide_tween: slide_tween.kill()
	var change_pos : Vector2 = closed_pos if inv_open else open_pos
	var external_change_pos : Vector2 = external_closed_pos if inv_open else external_open_pos
	slide_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	slide_tween.tween_property(inventory_panel, "position", change_pos, inv_slide_duration)
	slide_tween.tween_property(external_inventory, "position", external_change_pos, inv_slide_duration)

	inv_open = !inv_open


func set_inventory_data(invref : InventoryRef, is_player := false) -> void:
	invref.inventory_interact.connect(_on_inventory_interact)
	if is_player:
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


func change_active_slot(index : int) -> void :
	if index == active_slot: return
	active_slot = wrapi(index, 0, 5)
	active_slot_changed.emit(active_slot)

	var desired_x_pos := inventory_panel.position.x + (100 * active_slot) + 8
	if hotbar_tween: hotbar_tween.kill()
	hotbar_tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	hotbar_tween.tween_property(active_selector, "position:x", desired_x_pos, inv_slide_duration)


func _on_gui_input(event): # drop grabbed slot if clicked out of inventory
	if (event is InputEventMouseButton
		and (event.button_index == MOUSE_BUTTON_LEFT
		or event.button_index == MOUSE_BUTTON_RIGHT)
		and event.is_pressed()
		and is_instance_valid(grabbed_slotref)):
		Global.spawn_item_pop(grabbed_slotref, player.item_holder.global_position, player.throw_force)
		grabbed_slotref = null
		update_grabbed_slot()
