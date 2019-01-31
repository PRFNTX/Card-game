extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var life = -1
export(int,"Orb") var target = 0

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(type,target,set_state=null):
	if target>0 and target<45:
		if type.to_lower().find('attack')>=0 and not Game.get_hex_by_id(target).get_unit().Owner==-1:
			if Game.get_hex_by_id(target).get_unit().Owner != entity.Owner:
				if entity.Owner==0:
					Game.get_hex_by_id(44).get_unit().life_change(-1)
				elif entity.Owner == 1:
					Game.get_hex_by_id(1).get_unit().life_change(-1)
			
