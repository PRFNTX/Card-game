extends Node

export(int,'Gold','Faeria') var resource=0
export(int,"Owner","Opponent") var target_player = 1
export(int,"Owner","Opponent") var gain_player = 0

func activate(Game,entity,unused):
	if resource==0:
		value = Game.players[(entity.Owner+target_player)%2].gold
		Game.players[(entity.Owner+gain_player)%2].modCoin(value)
	else:
		value = Game.players[(entity.Owner+target_player)%2].faeria
		Game.players[(entity.Owner+gain_player)%2].modFaeria(add_amount)
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


