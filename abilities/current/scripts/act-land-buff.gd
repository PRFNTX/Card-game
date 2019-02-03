extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "Empty","Land","Lake","Tree","Hill","Sand") var land_type = 3
export(int) var val = 1

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

var conv_type = [0,2,3,4,5,6]
var up = false
func activate(type,target,set_state=null):
	if not up and entity.Hex.stateLocal.hex_type == conv_type[land_type]:
		entity.Unit.current_attack += val
		up = true
	elif up and not entity.Hex.stateLocal.hex_type == conv_type[land_type]:
		entity.Unit.current_attack -= val
		up = false
