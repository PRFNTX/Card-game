extends Control

var Unit
var Game setget set_game
var Hex
var Owner setget set_owner

var card_name

var stunned = false

export(Color, RGBA) var enemy_modulate = Color(0,0,0,0)

func set_owner(val):
	Owner = val
	if val == 1:
		Unit.modulate=enemy_modulate

func set_game(val):
	Game = val
	Game.connect('TurnStart', self, 'sig_turn_start')
	Game.connect('UpdateState', self, 'sig_update_state')

#func spawn_faeria():
#	Game.connect('SpawnFaeria',self,'sig_spawn_faeria')

var actionList={}

var state={
	'active':false,
	'clock_time':0,
	'delegate':null
}

func _ready():
	pass

func possess(entity, hex, player, game,_card_name):
	Owner = player
	set_process_input(true)
	card_name=_card_name
	
	Unit = entity.instance()
	add_child(Unit)
	Game= game
	Unit.init()
	actionList = Unit.get_actions()
	Hex = hex
	
	Game.connect('TurnStart', self, 'sig_turn_start')
	Game.connect('UpdateState', self, 'sig_update_state')
	print(Owner)
	return Unit.play()

func receive_attack(val_damage):
	var mod_damage = on_damage(val_damage)
	if Unit.is_unit:
		Unit.set_health(Unit.current_health-mod_damage)
		if Unit.current_health <=0:
			on_death()
	elif Unit.is_building:
		Unit.set_val(Unit.current_val-mod_damage)
		if Unit.current_val <=0:
			on_death()

## currently identical to above
func receive_damage(val_damage):
	var mod_damage = on_damage(val_damage)
	if Unit.is_unit:
		Unit.set_health(Unit.current_health-mod_damage)
		if Unit.current_health <=0:
			on_death()
	elif Unit.is_building:
		Unit.set_val(Unit.current_val-mod_damage)
		if Unit.current_val <=0:
			on_death()

## as above but damage is not reduced
func life_change(val):
	if val<0:
		on_damage(val)
	
	if Unit.is_unit:
		Unit.set_health(Unit.current_health+val)
		if Unit.current_health <=0:
			on_death()
	elif Unit.is_building:
		Unit.set_val(Unit.current_val+val)
		if Unit.current_val <=0:
			on_death()

func actions_populate():
	#for act in actionList.keys():
	#	$Actions.add_item(act)
	pass

func activate(ability):
	actionList[ability].activate(Game, self, null)

func use_energy(num=1):
	Unit.current_energy-=num

func get_energy():
	return Unit.current_energy

#### EVENT FUNCTIONS
func on_play():
	if Unit.on_play:
		Unit.play()

func on_attack(target):
	Unit.attack(target)
	target.receive_attack(Unit.current_attack)

func on_move(target): #hexEntity
	get_parent().remove_child(self)
	target.add_child(self)
	if Unit.on_move:
		Unit.move(target.get_parent())
	
func on_collect():
	if Unit.on_collect:
		Unit.collect()

func on_damage(val_damage):
	if Unit.on_damage:
		return Unit.damage(val_damage)
	else:
		return val_damage

func on_death():
	if Unit.on_death:
		Unit.death()
	if Unit.is_building or Unit.is_unit:
		queue_free()






### STATE

func setState(newState):
	for val in newState.keys():
		call(val,newState[val])


### STATE FUNCTIONS

func active(newVal):
	state['active']= newVal
	if newVal:
		$light.show()
		
	else:
		$light.hide()

func clock_time(time):
	state['clock_time']=time
	if Unit.on_clock:
		Unit.clock(time)

func delegate(nodepath):
	state['delegate'] = nodepath

func get_delegate():
	return Unit.get_node(state['delegate'])

### SIGNAL FUNCTIONS

func sig_turn_start(player):
	if player==Owner:
		Unit.turn_start(stunned)
	stunned = false

func spawn_faeria():
	Unit.add_one_faeria()

var watch = ['active','clock_time']
func sig_update_state(newState,keys):
	for key in keys:
		if watch.has(key):
			setState({key:newState[key]})


######

func _gui_input(event):
	if event.is_action('click') and event.is_action_released('click') and (Unit.current_energy>0 or int(Unit.abilities)==int(true)) and Owner==0:
		#Unit.on_select(Game,Hex)
		Game.activate(self)

func _on_Actions_item_selected( index ):
	actionList[$Actions.get_item_text(index)].start_action(Game)
