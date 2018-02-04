extends Node

export(int,'Gold','Faeria') var resource=0
export(int) var add_amount = 0

func activate(Game,entity,unused):
	if resource==0:
		Game.players[player].modCoin(add_amount)
	else:
		Game.players[player].modFaeria(add_amount)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
