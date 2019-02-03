extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(bool) var empty = false
export(bool) var orb = false
export(bool) var well = false
export(bool) var land = false
export(bool) var lake = false
export(bool) var tree = false
export(bool) var hill = false
export(bool) var sand = false

export(int) var max_health = 5

onready var conds = [
	empty,
	orb,
	land,
	lake,
	tree,
	hill,
	sand,
	well,
]

func activate(Game, entity, target):
	var cond1 = conds[Game.get_hex_by_id(target).stateLocal.hex_type]
	var cond2 = entity.Unit.current_health < max_health
	return cond1 and cond2