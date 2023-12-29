extends Resource
class_name InventoryRef

signal inventory_interact(invref: InventoryRef, index: int, button: int)
signal inventory_updated(invref: InventoryRef)

@export var slotref_list : Array[SlotRef] = []


func get_slotrefs() -> Array[SlotRef] :
	return slotref_list


func get_slotref(index : int) -> SlotRef :
	return slotref_list[index]


func set_slotref(index : int, value : SlotRef) -> void :
	slotref_list[index] = value


func grab_slotref(index : int) -> SlotRef :
	var slotref = get_slotref(index)
	if slotref:
		set_slotref(index, null)
		inventory_updated.emit(self)
		return slotref
	else:
		return null


func grab_half_slotref(index : int) -> SlotRef :
	var slotref = get_slotref(index).duplicate()
	if slotref:
		if slotref.amount == 1: return grab_slotref(index)
		var half_amount = round(slotref.amount / 2)
		get_slotref(index).amount = half_amount
		slotref.amount -= half_amount
		inventory_updated.emit(self)
		return slotref
	else:
		return null


func drop_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef :
	var slotref = get_slotref(index)

	if slotref and slotref.can_merge_with(grabbed_slotref):
		var grabbed := slotref.merge_with(grabbed_slotref)
		inventory_updated.emit(self)
		return grabbed
	else:
		set_slotref(index, grabbed_slotref)
		inventory_updated.emit(self)
		return slotref


func drop_single_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef :
	var slotref = get_slotref(index)

	if not slotref:
		set_slotref(index, grabbed_slotref.create_single_slotref())
	elif slotref.can_merge_with(grabbed_slotref, true):
		slotref.merge_with(grabbed_slotref, true)

	inventory_updated.emit(self)

	if grabbed_slotref.amount > 0:
		return grabbed_slotref
	else:
		return null


func pick_up_slotref(pickup : SlotRef) -> bool :
	for ref in get_slotrefs():
		if ref.can_merge_with(pickup):
			ref.merge_with(pickup)
			return true
	return false


func delete_slotref(index : int) -> void :
	set_slotref(index, null)
	inventory_updated.emit(self)


func add_slotref(input : SlotRef) -> SlotRef :
	var slotref := input.duplicate()
	var i := 0
	for space in get_slotrefs():
		if space == null:
			set_slotref(i, slotref)
			slotref = null
			inventory_updated.emit(self)
			return null
		if space.can_merge_with(slotref):
			var remainder := space.merge_with(slotref)
			if remainder == null:
				inventory_updated.emit(self)
				return null
			else: add_slotref(remainder)
		i += 1
	return slotref


func _on_slot_clicked(index : int, button : int) -> void :
	inventory_interact.emit(self, index, button)
	#print("inventory interacted at index ", str(index), " with button ", str(button))
