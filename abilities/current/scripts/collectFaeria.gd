extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

var Game
var entity
func init(_entity):
	entity=_entity
	Game=entity.Game

func activate(Game, entity, by):
	var harvested = entity.Unit.current_faeria
	Game.players[by.Owner].modFaeria(harvested)
	entity.Unit.current_faeria = 0
	by.on_collect(harvested)
	return false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
