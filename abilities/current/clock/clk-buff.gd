extends Node

export(int) var value = 1
export(bool) var night = true
export(bool) var evening = false
export(bool) var morning = false
export(String) var modName = "lunarMochi"

var Game
var entity
func init(_entity):
	entity=_entity
	Game = entity.Game

const MORNING = 0
const EVENING = 1
const NIGHT = 2


func activate(_game, _entity, time):
	if time==MORNING and morning:
		entity.Unit.mod_att(modName, 1)
	elif time==EVENING and evening:
		entity.Unit.mod_att(modName, 1)
	elif time==NIGHT and night:
		entity.Unit.mod_att(modName, 1)
	else:
		entity.Unit.unmod_att(modName)