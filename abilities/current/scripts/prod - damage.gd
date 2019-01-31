extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int, "Owner", "Opponent") var player = 1
export(int) var damage = -1
export(int, 'Orb') var target = 0 #not implemented


func activate(Game, entity, unused):
	var hex
	
	if player == entity.Owner:
		hex = Game.get_hex_by_id(1)
	elif player != entity.Owner:
		hex = Game.get_hex_by_id(44)
	
	if hex.has_unit():
		hex.get_unit().life_change(damage)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
