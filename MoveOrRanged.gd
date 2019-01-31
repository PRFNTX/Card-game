extends Node

export(int, "None", "Aquatic", "Flying") var medium = 0


var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func start_action(entity):
	activate(entity.Game,entity,null)

func activate(_game, _entity, _val):
	Game = _game
	entity = _entity
	Game.delegate_action(entity.Hex.id,get_parent().get_name()+'/'+get_name())

func targeting_move(hex):
	if medium==0:
		if hex.hexType.child.moveLand and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
			hex.setState({'cover':hex.move,'target':true})
			return true
		else:
			hex.setState({'cover':Color(0,0,0,0), 'target':false})
	elif medium==2:
		if hex.hexType.child.moveAir and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
			hex.setState({'cover':hex.move,'target':true})
			return true
		else:
			hex.setState({'cover':Color(0,0,0,0), 'target':false})
	elif medium==1:
		if hex.hexType.child.moveWater and hex.hex_is_empty_or_self() and hex.is_adjacent_or_equal_to(hex.stateLocal['active_unit'].Hex):
			hex.setState({'cover':hex.move,'target':true})
			return true
		else:
			hex.setState({'cover':Color(0,0,0,0), 'target':false})

func targeting_attack(hex):
	if (hex.has_attackable_opposing_unit()):
		hex.setState({'cover':hex.attack,'target':true})
		return true
	else:
		hex.setState({'cover':Color(0,0,0,0), 'target':false})

var adj = []
var ranged_area = []
func targeting():
	adj = entity.Hex.adjacent
	for hex in adj:
		if not ranged_area.has(hex):
			ranged_area.append(hex)
	var found_target = false
	for hex in adj:
		if targeting_move(hex):
			found_target = true
	for hex in ranged_area:
		if targeting_attack(hex):
			found_target = true
	if not found_target:
		Game.no_target_found()
	
func complete(target, set_state=null):
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	
	var hex_target = Game.get_hex_by_id(target)
	if adj.has(hex_target):
		entity.on_move(hex_target.get_node('hexEntity'))
	else:
		entity.on_attack(hex_target.get_node('hexEntity'))
	
	if local:
		Game.send_action('delegate',45-target,{'delegate_id':45-entity.Hex.id, 'delegate_node':get_parent().get_name()+'/'+get_name()})
	
	entity.use_energy(1)
	entity.Hex=hex_target
	
	if Game.check_valid_action(entity.Unit.get_action_name('Collect')) and local and entity.Unit.current_health>0:
		Game.setState({'active_unit':entity.Hex.id})
		Game.actionReady=true
		entity.Unit.start_attack(Game)
	else:
		return true

func cancel_action():
	adj = []
	ranged_area = []