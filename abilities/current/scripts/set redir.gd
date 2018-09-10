extends Node

var Game
var entity
func init(_entity):
	entity = _entity
	Game = entity.Game

func activate(Game,entity,dmg):
	redir_to.life_change(-1)
	return 0


var redir_to
func set(node):
	redir_to=node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
