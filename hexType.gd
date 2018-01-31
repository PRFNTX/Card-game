extends Node2D

export(PackedScene) var Empty
export(PackedScene) var Orb
export(PackedScene) var Land
export(PackedScene) var Lake
export(PackedScene) var _Tree
export(PackedScene) var Hill
export(PackedScene) var Sand
export(PackedScene) var Well

onready var arr_Lands=[Empty,Orb,Land,Lake,_Tree,Hill,Sand,Well]

class state:
	var me
	var state

	func _init(myself,i):
		me=myself
		state=i
		me.child=me.arr_Lands[i].instance()
		me.add_child(me.child)


var currentState
var child

func _ready():
	setState(0)


func setState(newState):
	currentState=state.new(self,newState)
