extends InventoryRef
class_name ArmorInventoryRef


func check_eligibility(new_slotref : SlotRef, index : int) -> bool :
	if index == 0:
		if new_slotref.itemref.tags.has("head"): return true
		else: return false
	elif index == 1:
		if new_slotref.itemref.tags.has("body"): return true
		else: return false
	return false


func emit_updated(index := -1) -> void :
	if index == 0:
		inventory_updated.emit(self, Player.BODY_SLOT.HEAD, index)
	elif index == 1:
		inventory_updated.emit(self, Player.BODY_SLOT.BODY, index)
