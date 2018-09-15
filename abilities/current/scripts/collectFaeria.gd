extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func activate(Game, entity,unsued):
	var val = entity.Unit.current_faeria
	entity.Unit.current_faeria = 0
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
