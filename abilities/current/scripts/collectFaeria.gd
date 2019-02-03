extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game, entity, _unused):
	var val = entity.Unit.current_faeria
	entity.Unit.current_faeria = 0
	print('collected')
	Game.players[Game.state['current_turn']].modFaeria(val)
	Game.emit_signal('on_collect', Game.state.active_unit, val)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
