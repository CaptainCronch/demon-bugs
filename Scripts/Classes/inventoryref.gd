extends Resource
class_name InventoryRef

signal inventory_interact(invref: InventoryRef, index: int, button: int)
signal inventory_updated(invref: InventoryRef)
signal slotref_changed(old_ref : SlotRef, new_ref : SlotRef) ## Used only for modifiers currently.

@export var slotref_list : Array[SlotRef] = []
@export var allowed_tag := ""


func get_slotrefs() -> Array[SlotRef] :
	return slotref_list


func get_slotref(index : int) -> SlotRef :
	return slotref_list[index]


func set_slotref(index : int, value : SlotRef) -> void :
	var old := slotref_list[index]
	slotref_list[index] = value
	slotref_changed.emit(old, value)


func grab_slotref(index : int) -> SlotRef : ## Called on primary click with empty hand.
	var slotref = get_slotref(index)
	if slotref:
		set_slotref(index, null)
		inventory_updated.emit(self)
		return slotref
	else:
		return null


func grab_half_slotref(index : int) -> SlotRef : ## Called on secondary click with empty hand.
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


func drop_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef : ## Called on primary click with grabbed slotref.
	var slotref := get_slotref(index)
	if not check_eligibility(grabbed_slotref, index): return grabbed_slotref

	if slotref and slotref.can_merge_with(grabbed_slotref):
		var grabbed := slotref.merge_with(grabbed_slotref)
		inventory_updated.emit(self)
		return grabbed
	else:
		set_slotref(index, grabbed_slotref)
		inventory_updated.emit(self)
		return slotref


func drop_single_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef : ## Called on secondary click with grabbed slotref.
	var slotref = get_slotref(index)
	if not check_eligibility(grabbed_slotref, index): return grabbed_slotref

	if not slotref:
		set_slotref(index, grabbed_slotref.create_single_slotref())
	elif slotref.can_merge_with(grabbed_slotref, true):
		slotref.merge_with(grabbed_slotref, true)

	inventory_updated.emit(self)

	if grabbed_slotref.amount > 0:
		return grabbed_slotref
	else:
		return null


#func pick_up_slotref(pickup : SlotRef) -> bool :
	#for ref in get_slotrefs():
		#if ref.can_merge_with(pickup):
			#if not check_eligibility(pickup, ref): continue
			#ref.merge_with(pickup)
			#return true
	#return false


func delete_slotref(index : int) -> void :
	slotref_changed.emit(get_slotref(index), null)
	set_slotref(index, null)
	inventory_updated.emit(self)


func add_slotref(input : SlotRef) -> SlotRef :
	var slotref := input.duplicate()
	var i := 0
	for space in get_slotrefs():
		if check_eligibility(slotref, i):
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


func check_eligibility(new_slotref : SlotRef, _index : int) -> bool :
	if not allowed_tag: return true
	if new_slotref.itemref.tags.has(allowed_tag): return true
	else: return false
