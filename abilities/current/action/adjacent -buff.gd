extends Node

var Game
var entity


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var value = 1
export(int, "Owner", "Opponent", "All") var player = 0

var _last = {}
var _refs = {}

func init(_entity):
	entity = _entity
	Game = entity.Game
	for hex in entity.Hex.adjacent:
		if hex.has_unit():
			_last[hex.id] = hex.get_unit()
			_refs[hex.id] = weakref(hex.get_unit())
			hex.get_unit().Unit.current_attack += 1
		else:
			_last[hex.id] = null
			_refs[hex.id] = false

func activate(type, target, state=null):
	var adjs = []
	for hex in entity.Hex.adjacent:
		adjs.append(hex.id)
	
	for unit_key in _last.keys():
		var unit = _last[unit_key]
		if unit != null and _refs[unit_key].get_ref():
			if not adjs.has(unit.Hex.id):
				if player==2:
					unit.Unit.current_attack -= value
				elif int(unit.Owner) == (int(entity.Owner)+int(player))%2:
					unit.Unit.current_attack -= value
	for hex in adjs:
		var hex_entity = Game.get_hex_by_id(hex)
		if hex_entity.has_unit():
			var unit = hex_entity.get_unit()
			if not _last.values().has(unit):
				if player==2:
					unit.Unit.current_attack += value
				elif int(unit.Owner) == (int(entity.Owner)+int(player))%2:
					unit.Unit.current_attack += value
	
	_last.clear()
	_refs.clear()
	for hex in entity.Hex.adjacent:
		_last[hex.id] = hex.get_unit()
		if hex.has_unit():
			_refs[hex.id] = weakref(hex.get_unit())
		else:
			_refs[hex.id] = false
	

