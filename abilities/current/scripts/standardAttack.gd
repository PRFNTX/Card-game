extends Node

export(bool) var collect_only = false

var entity
var Game
func init(_entity):
	entity=_entity
	Game=_entity.Game

func start_action(Game):
	if get_parent().get_parent().collect and get_parent().get_parent().attack and not collect_only:
		print('att or coll')
		Game.start_unit_action('AttackAdjOrCollect')
	elif get_parent().get_parent().collect:
		print('coll')
		Game.start_unit_action("Collect")
	elif not collect_only:
		print('att')
		Game.start_unit_action('AttackAdj')
	else:
		print('none')
		return false

func get_action_type():
	if get_parent().get_parent().collect:
		return('AttackAdjOrCollect')
	else:
		return('AttackAdj')

func verify_costs():
	return entity.get_energy()>=1
