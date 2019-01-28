extends Node

export(int,'Empty','Land','Lake','Tree','Hill','Sand') var type = 1
export(bool) var change_type = true
export(bool) var convert_land = false

var translate_hex_type = [0,2,3,4,5,6]

var exclude = [1, 7]

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,target):
	if !exclude.has(target.Hex.stateLocal.hex_type):
		if change_type:
			target.Hex.setState({'hex_type':translate_hex_type[type]})
		if convert_land:
			target.Hex.setState({'hex_owner':entity.owner})
	Game.update_lands_owned()
