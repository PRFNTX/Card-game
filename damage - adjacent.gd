extends Node

var Game
var entity

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
	

func activate(type, target, state=null):
	var adjs = []
	for hex in entity.Hex.adjacent:
		adjs.append(hex.id)
	if adjs.has(target):
		for hex in _last.keys():
			if not Game.get_hex_by_id(hex).get_unit() == _last[hex]:
				if player==2:
					_last[hex].receive_damage(1)
				elif _last[hex].Owner == (entity.Owner+player)%2:
					_last[hex].receive_damage(1)
	_last.clear()
	for hex in entity.Hex.adjacent:
		_last[hex.id] = hex.get_unit()
	
	

