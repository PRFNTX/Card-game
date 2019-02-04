extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

func activate(Game, entity, _unused_or_id):
	var by_unit = Game.state.active_unit
	if by_unit == null:
		by_unit == Game.state.delegate_id
	if by_unit == null:
		by_unit = _unused_or_id
	var val = entity.Unit.current_faeria
	entity.Unit.current_faeria = 0
	if by_unit != null:
		var unit_node = Game.get_hex_by_id(by_unit).get_unit()
		Game.players[unit_node.Owner].modFaeria(val)
	else:
		Game.players[Game.state['current_turn']].modFaeria(val)
	Game.emit_signal('on_collect', by_unit, val)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
