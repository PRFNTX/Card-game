extends Node

export(bool) var emtpy = false
export(bool) var orb = false
export(bool) var well = false
export(bool) var land = false
export(bool) var lake = false
export(bool) var tree = false
export(bool) var hill = false
export(bool) var sand = false

var conds = [
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
	return conds[game.get_hex_by_id(target).stateLocal.hex_type]