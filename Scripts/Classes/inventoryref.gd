extends Resource
class_name InventoryRef

signal inventory_interact(invref: InventoryRef, index: int, button: int)
signal inventory_updated(invref: InventoryRef)

@export var slotrefs : Array[SlotRef] = []


func grab_slotref(index : int) -> SlotRef :
	var slotref = slotrefs[index]
	if slotref:
		slotrefs[index] = null
		inventory_updated.emit(self)
		return slotref
	else:
		return null


func grab_half_slotref(index : int) -> SlotRef :
	var slotref = slotrefs[index].duplicate()
	if slotref:
		if slotref.amount == 1: return grab_slotref(index)
		var half_amount = round(slotref.amount / 2)
		slotrefs[index].amount = half_amount
		slotref.amount -= half_amount
		inventory_updated.emit(self)
		return slotref
	else:
		return null


func drop_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef :
	var slotref = slotrefs[index]

	var return_slotref: SlotRef
	if slotref and slotref.can_merge_with(grabbed_slotref):
		var grabbed := slotref.merge_with(grabbed_slotref)
		inventory_updated.emit(self)
		return grabbed
	else:
		slotrefs[index] = grabbed_slotref
		return_slotref = slotref
		inventory_updated.emit(self)
		return slotref


func drop_single_slotref(grabbed_slotref : SlotRef, index : int) -> SlotRef :
	var slotref = slotrefs[index]

	if not slotref:
		slotrefs[index] = grabbed_slotref.create_single_slotref()
	elif slotref.can_merge_with(grabbed_slotref, true):
		slotref.merge_with(grabbed_slotref, true)

	inventory_updated.emit(self)

	if grabbed_slotref.amount > 0:
		return grabbed_slotref
	else:
		return null


func pick_up_slotref(pickup : SlotRef) -> bool :
	for ref in slotrefs:
		if ref.can_merge_with(pickup):
			ref.merge_with(pickup)
			return true
	return false


func _on_slot_clicked(index : int, button : int) -> void :
	inventory_interact.emit(self, index, button)
	#print("inventory interacted at index ", str(index), " with button ", str(button))
