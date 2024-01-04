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
