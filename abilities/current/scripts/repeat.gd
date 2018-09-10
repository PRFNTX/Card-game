extends Node

var Game
var entity
func init(_entity):
	entity = _entity
	Game=entity.Game


export(int) var times=3
var iter= 1

func activate(Game,entity,val):
	var ab = get_children()[0]
	Game.newAction()
	ab.activate(Game,entity,val)
	return false

func repeat():
	if iter<times:
		Game.newAction()
		activate(Game,entity,'none')
		iter+=1
		return true
	else:
		return false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
