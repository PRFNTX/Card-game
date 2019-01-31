extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int,'All','Orb','Unit') var on_target = 1
export(int,'Gold','Faeria','Cards','Actions') var res = 2
export(bool) var val_by_damage = false
export(int) var val = 3

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game,entity,target):
	if on_target==0:
		resources(target)
	elif on_target==1 and (target.Hex.id==1 or target.Hex.id ==44):
			resources(target)
	elif on_target==2 and not (target.stateLocal['hex_type']==7 or target.stateLocal['hex_type']==1):
		resources(target)

func resources(target):
	var value = val
	if val_by_damage:
		if target.Unit.is_unit:
			value = min(target.current_health, entity.Unit.current_attack)
		else:
			value = min(target.current_val, entity.Unit.current_attack)
	if res == 0:
		Game.players[entity.Owner].modCoin(value)
	elif res==1:
		Game.players[entity.Owner].modFaeria(value)
	elif res==2:
		Game.players[entity.Owner].modActions(value)
	elif res==3:
		for i in value:
			Game.players[entity.Owner].drawCard()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
