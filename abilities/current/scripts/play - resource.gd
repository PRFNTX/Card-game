extends Node

export(int,"Gold","Faeria","Actions","Cards") var type = 3
export(int) var value = 1
export(bool) var then_free = true

func activate(Game, entity, unused):
	if type == 0:
		Game.players[entity.Owner].modCoin(value)
	elif type==1:
		Game.players[entity.Owner].modFaeria(value)
	elif type==2:
		Game.players[entity.Owner].modActions(value)
	elif type==3:
		for i in value:
			Game.players[entity.Owner].drawCard()
	if then_free:
		entity.queue_free()
	return null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
