extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,target):
	Game.get_hex_by_id(target).setState({'hex_owner':entity.Owner})
	Game.update_lands_owned()
