extends Node

export(bool) var morning = 0
export(bool) var evening = 0
export(bool) var night = 0



const MORNING=0
const EVENING=1
const NIGHT=2

func activate(Game,entity,time):
	if time==MORNING and morning:
		entity.spawn_faeria()
	if time==EVENING and evening:
		entity.spawn_faeria()
	if time==NIGHT and night:
		entity.spawn_faeria()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


