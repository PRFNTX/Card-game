extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(Dictionary) var morning = {
	'isAttackable': true,
}
export(Dictionary) var evening = {
	'isAttackable': false,
}
export(Dictionary) var night = {
	'isAttackable': false,
}

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var MORNING=0
var EVENING=1
var NIGHT=2


var time 

func activate(_Game,_entity,_time):
	Game = _Game
	entity = _entity
	time= _time
	
	if time==MORNING:
		setProperties(morning)
	if time==EVENING and evening:
		setProperties(evening)
	if time==NIGHT and night:
		setProperties(night)

func setProperties(objProps):
	for property in objProps.keys():
		entity[property] = objProps[property]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass