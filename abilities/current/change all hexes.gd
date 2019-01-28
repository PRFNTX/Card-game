extends Node

export(int, "Empty", "Land", "Land", "Tree", "Hill", "Sand") var to_type = 1
export(bool) var affect_empty = false

var conv_type = [0,2,3,4,5,6]
func activate(Game,entity,val):
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.id>0 and not hex.stateLocal.hex_type == hex.TYPE_ORB and not hex.stateLocal.hex_type == hex.TYPE_WELL:
			if (
				(affect_empty and hex.stateLocal.hex_type == hex.TYPE_EMPTY)
				or not hex.stateLocal.hex_type == hex.TYPE_EMPTY
			): 
				hex.setState({'hex_type':conv_type[to_type]})
				if to_type==0:
					hex.setState({'hex_owner': -1})
	Game.update_lands_owned()
