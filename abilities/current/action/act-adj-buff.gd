extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "self", "enemy", "any") var adj_owner = 0
export(int) var value
export(bool) var buff_self = true
export(String) var buff_name = "MochiFellow"

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game
	activate(0, 'nothing', null)

func activate(target, somehting, set_state=null):
	var hexes = entity.Hex.adjacent
	var active = false
	for hex in hexes:
		if hex.has_friendly_unit() and hex.unit_is_creature():
			var unit = hex.get_unit()
			if unit.Owner == entity.Owner:
				active=true
	if active:
		entity.Unit.set_mod_att(buff_name, value)
	else:
		entity.Unit.unmod_att(buff_name)