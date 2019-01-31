extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int,'Gold','Faeria') var resource=0
export(int) var add_amount = 0
export(int,"Owner","Opponent") var target_player = 0

func activate(Game,entity,unused):
	if resource==0:
		Game.players[(entity.Owner+target_player)%2].modCoin(add_amount)
	else:
		Game.players[(entity.Owner+target_player)%2].modFaeria(add_amount)
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


