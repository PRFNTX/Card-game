extends Node

export(int) var power = 1
export(int) var health = 0
export(int) var energy = 0
export(PackedScene) var unbuffer = null
export(String) var buff_name = "NaturesGrowth"

func activate(game, entity, target):
	var name = entity.Unit.mod_att(buff_name, power, true)
	var inst_unbuff = unbuffer.instance()
	unbuffer.