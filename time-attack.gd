extends Node

var entity
var Game

func init():
	entity = _entity
	Game = entity.game


func activate(_Game,_entity,_time):
    Game = _Game
    entity = _entity
    time= _time

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
