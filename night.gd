extends Node

export(bool) var morning = 0
export(bool) var evening = 0
export(bool) var night = 0

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


const MORNING=0
const EVENING=1
const NIGHT=2

var Game
var entity
var time 

func activate(_Game,_entity,_time):
	Game = _Game
	entity = _entity
	time= _time
	
	if time==MORNING and morning:
		fisherman()
	if time==EVENING and evening:
		entity.spawn_faeria()
	if time==NIGHT and night:
		entity.spawn_faeria()

func fisherman():
	if Game.state['current_time']==2 and entity.Hex.stateLocal['hex_type'] == land_occupied:
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


