extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game,entity,none):
	for hex in get_tree().get_nodes_in_group('Hex'):
		Game.players[entity.Owner].modFaeria(hex.get_unit().Unit.current_faeria)
		hex.get_unit.Unit.current_faeria=0
		

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
