extends Resource
class_name SlotRef

@export var itemref : ItemRef
@export var amount := 1 : set = set_amount

var allowed_tag := ""


func can_merge_with(other_slotref: SlotRef, single := false) -> bool :
	return (itemref == other_slotref.itemref
			and itemref.stackable
			and amount < itemref.max_stack
			and (other_slotref.amount < itemref.max_stack or single))


func merge_with(other_slotref: SlotRef, single := false) -> SlotRef :
	if single:
		set_amount(amount + 1)
		other_slotref.set_amount(other_slotref.amount - 1)
		if other_slotref.amount == 0:
			return null
		else: return other_slotref

	var total := amount + other_slotref.amount
	if total > itemref.max_stack:
		set_amount(itemref.max_stack)
		other_slotref.set_amount(total - itemref.max_stack)
		return other_slotref
	else:
		set_amount(total)
		return null


func create_single_slotref() -> SlotRef:
	var new_slotref : SlotRef = duplicate()
	new_slotref.set_amount(1)
	set_amount(amount - 1)
	return new_slotref


func set_amount(value : int) -> void :
	amount = value
	if not itemref.stackable and amount > 1:
		amount = 1
		push_error(str(itemref), " is unstackable but you tried to add more than 1")
