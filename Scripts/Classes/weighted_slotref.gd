extends SlotRef
class_name WeightedSlotRef

@export var weight := 1
@export var amount_range : Array[int] = [1] ## Only first two values count.


func consolidate() -> SlotRef :
	var slotref : SlotRef = SlotRef.new()
	slotref.itemref = itemref
	if amount_range.size() >= 2:
		slotref.amount = randi_range(amount_range[0], amount_range[1])
	return slotref
