extends ArmorModifier


func update_bonuses() -> void :
	for mod in mod_comp.get_children():
		if mod.id == set_partner:
			mod_comp.target.health_comp.defense_bonus.add_bonus("beekeeper_set", set_defense)
			return
	mod_comp.target.health_comp.defense_bonus.remove_bonus("beekeeper_set")
