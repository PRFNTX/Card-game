extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(bool) var morning = 0
export(bool) var evening = 0
export(bool) var night = 1

export(int,"GOLD","FAERIA","ACTIONS","CARDS") var type = 0
export(int, "OWNER","OPPONENT") var player = 0
export(int) var gained = 3
export(int,"EMPTY","ORB","LAND","LAKE","TREE","HILL","SAND","WELL") var land_occupied = 3 #Hex.STATE_LAKE
"""
const STATE_EMPTY=0
const STATE_ORB=1
const STATE_LAND=2
const STATE_LAKE=3
const STATE_TREE=4
const STATE_HILL=5
const STATE_SAND=6
const STATE_WELL=7
"""
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
	
	if time==MORNING and morning:
		fisherman()
	if time==EVENING and evening:
		fisherman()
	if time==NIGHT and night:
		fisherman()

func fisherman():
	if entity.Hex.stateLocal['hex_type'] == land_occupied:
		if type==0:
			Game.players[entity.Owner+player].modCoin(gained)
		elif type==1:
			Game.players[entity.Owner+player].modFaeria(gained)
		elif type==2:
			Game.players[entity.Owner+player].modActions(gained)
		elif type==3:
			if gained > 0:
				for i in gained:
					Game.players[entity.Owner+player].drawCard()
			else:
				for i in -1*gained:
					Game.players[entity.Owner+player].discard_hand()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


