extends Node

var track_entities = {}

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game
	Game.connect('ActionPhase', self, '_remove_energy')
	for init_entity in get_tree().get_nodes_in_group('entities'):
		track_entities[init_entity] = init_entity.get_energy()

func activate(type,target,set_state=null):
	_remove_energy(null)

func _remove_energy(_unused):
	for other_entity in get_tree().get_nodes_in_group('entities'):
		if not weakref(other_entity).get_ref():
			pass
		elif not other_entity.Unit.is_building:
			if not track_entities.keys().has(other_entity):
				track_entities[other_entity] = 0
			elif other_entity.get_energy() > track_entities[other_entity]:
				other_entity.Unit.current_energy = track_entities[other_entity]
			else:
				track_entities[other_entity] = other_entity.get_energy()