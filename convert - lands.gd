extends Node

#export(int, "All", "Owner", "opposing") var this_unit_only = 0
var land_types = ['empty', 'orb', 'land','lake','tree','hill','sand','well']


func activate(Game, entity, unsused):
	for ent in get_tree().get_nodes_in_group('entities'):
		if ent.Hex.has_friendly_unit(entity.Owner) and ent.Hex.stateLocal['hex_owner']!=entity.Owner:
			ent.Hex.setState({'hex_owner':entity.Owner})
	Game.update_lands_owned()
	""" now handled in hexes
	Game.players[entity.Owner].modLands(land_types[hex.stateLocal['hex_type']],1)
	Game.players[(entity.Owner+1)%2].modLands(land_types[hex.stateLocal['hex_type']],1)
	"""
	return null
	
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
