extends Node

var Game
var entity

export(int) var value = 1
export(int, "Owner", "Opponent", "All") var player = 0

var _last = {}

func init(_entity):
	entity = _entity
	Game = entity.Game
	for hex in entity.Hex.adjacent:
		if hex.has_unit():
			_last[hex.id] = hex.get_unit()
		else:
			_last[hex.id] = null

func activate(type, target, state=null):
	var adjs = []
	for hex in entity.Hex.adjacent:
		adjs.append(hex.id)
	
	for hex in _last.keys():
		var unit = _last[hex]
		if unit.Hex.id != hex and adjs.has(unit.Hex.id):
			if player==2:
				unit.current_attack -= value
			elif int(unit.Owner) == (int(entity.Owner)+int(player))%2:
				unit.current_attack -= value
	for hex in adjs:
		if hex.has_unit():
			var unit = hex.get_unit()
			if not _last.values().has(unit):
				if player==2:
					unit.current_attack -= value
				elif int(unit.Owner) == (int(entity.Owner)+int(player))%2:
					unit.current_attack -= value
	
	_last.clear()
	for hex in entity.Hex.adjacent:
		_last[hex.id] = hex.get_unit()
	
	

