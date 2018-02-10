extends Node

export(int,"Land","Lake","Tree","Hill","Sand") var newType = 2
export(bool) var change_owner = true
export(bool) var affect_empty = true


func activate(Game, entity, unused):
	for hex in Game.get_hex_by_id(entity.Hex).adjacent:
		if change_owner and affect_empty:
			hex.setState({'hex_type':newType+2,'hex_owner':entity.Owner})
			
		elif affect_empty:
			if hex.stateLocal['hex_owner']>=0:
				hex.setState({'hex_type':newType+2})
			else:
				hex.setState({'hex_type':newType+2,'hex_owner':entity.Owner})
		else:
			if hex.stateLocal['hex_type']>=2 and hex.stateLocal['hex_type']<=6:
				hex.setState({'hex_type':newType+2})
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


