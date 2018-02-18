extends Node

func activate(Game,entity,val):
	for hex in get_tree().get_nodes_in_group('Hex'):
		if hex.id>0 and not hex.has_unit():
			hex.setState({'hex_type':0,'hex_owner':-1})

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
