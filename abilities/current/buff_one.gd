extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var power = 1
export(PackedScene) var unbuffer = null
export(String) var buff_name = "NaturesGrowth"
#unbuffer needs to account for enemy units
export(int, "friendly") var player = 0

func activate(game, entity, target):
	var name = entity.Unit.mod_att(buff_name, power, true)
	var inst_unbuff = unbuffer.instance()
	unbuffer.set_mod_name(name)
	entity.Unit.get_node('on_end_turn').add_child(unbuffer)
	entity.Unit.on_end_turn = true