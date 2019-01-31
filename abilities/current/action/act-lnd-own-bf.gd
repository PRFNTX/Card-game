extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "friendly", "enemy") var land_owner = 1
export(int) var val = 1

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

var up = false
func activate(type,target,set_state=null):
	if not up and conditions():
		entity.Unit.current_attack += val
	elif up and not conditions():
		entity.Unit.current_attack -= val

func condition():
	if land_owner==0 and entity.Hex.stateLocal.hex_owner == entity.Owner:
		return true
	if land_owner==1 and not entity.Hex.stateLocal.hex_owner == entity.Owner:
		return true
	return false
