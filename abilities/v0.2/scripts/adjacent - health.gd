extends Node

export(int,"all","Owner","Opponent") var target_player = 1
export(int, "Unit","Creature","Building") var target_type = 1

export(int) var life = 1

func activate(Game,entity,unused):
	var hex = Game.get_hex_by_id(entity.Hex)
	for oneHex in hex.adjacent:
		if target_type==0:
			if oneHex.has_unit() and (target_player==0 or (target_player == 1 and oneHex.has_friendly_unit(entity.Owner)) or (target_player == 1 and oneHex.has_opposing_unit(entity.Owner))):
				oneHex.get_unit().life_change(life)
		elif target_type==1:
			if oneHex.unit_is_creature() and (target_player==0 or (target_player == 1 and oneHex.has_friendly_unit(entity.Owner)) or (target_player == 1 and oneHex.has_opposing_unit(entity.Owner))):
				oneHex.get_unit().life_change(life)
		elif target_type==2:
			if oneHex.unit_is_building() and (target_player==0 or (target_player == 1 and oneHex.has_friendly_unit(entity.Owner)) or (target_player == 1 and oneHex.has_opposing_unit(entity.Owner))):
				oneHex.get_unit().life_change(life)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
