extends Modifier
class_name ArmorModifier

@export var defense : float
@export var set_defense : float ## Only to be set by the head piece.
@export var set_partner : StringName ## Only the head piece should care.


func enable():
	mod_comp.target.health_comp.defense_bonus.add_bonus(String(id), defense)


func disable():
	mod_comp.target.health_comp.defense_bonus.remove_bonus(String(id))
