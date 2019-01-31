extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "Land","Lake","Tree","Hill","Sand") var type = 1

var change_type = [2,3,4,5,6]

func activate(Game,entity,unused):
	if entity.Hex.stateLocal.hex_type==0:
		entity.Hex.setState({
			'hex_type': change_type[type],
			'hex_owner': entity.Owner
		})
		Game.update_lands_owned()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

