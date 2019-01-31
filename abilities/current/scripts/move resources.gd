extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var value = 1
export(int, "Gold", "Faeria", "Actions", "Cards") var type = 0


func activate(Game, entity, target):
	if Game.get_hex_by_id(target).stateLocal['hex_owner']!=entity.Owner:
		if type == 0:
			Game.players[entity.Owner].modCoin(value)
		elif type==1:
			Game.players[entity.Owner].modFaeria(value)
		elif type==2:
			Game.players[entity.Owner].modActions(value)
		elif type==3:
			for i in value:
				Game.players[entity.Owner].drawCard()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
