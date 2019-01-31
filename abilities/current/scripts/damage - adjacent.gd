extends Node

var Game
var entity


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var damage = 1
export(int, "Owner", "Opponent", "All") var player = 0

var _last = {}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func init(_entity):
	entity = _entity
	Game = entity.Game
	for hex in entity.Hex.adjacent:
		#if hex.has_unit():
			_last[hex.id] = hex.get_unit()
		#else:
		#	_last[hex.id] = null

func activate(type, target, state=null):
	var adjs = []
	for hex in entity.Hex.adjacent:
		adjs.append(hex.id)
	
	
	if adjs.has(target):
		
		for hex in _last.keys():
			
			if Game.get_hex_by_id(hex).has_unit():
				var unit = Game.get_hex_by_id(hex).get_unit()
				if unit != _last[hex]:
					if player==2:
						unit.receive_damage(1)
					elif int(unit.Owner) == (int(entity.Owner)+int(player))%2:
						unit.receive_damage(1)
	_last.clear()
	for hex in entity.Hex.adjacent:
		_last[hex.id] = hex.get_unit()
	
	

