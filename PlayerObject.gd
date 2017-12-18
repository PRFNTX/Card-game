
extends Node2D

var GameNode

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func OnCreate(node):
	GameNode=node
	node.connect("TurnStart",self,"sig_TurnStart")
	node.connect("ActionPhaseStart",self,"sig_ActionPhase")
	node.connect("TurnEnd",self,"sig_TurnEnd")
	#node.connect("TurnStart",self,"sig_TurnStart")

func sig_TurnStart():
	get_node("Gold").set_text(str(GameName.LocalPlayer.Gold))

func sig_ActionPhase():
	pass

func sig_TurnEnd():
	pass
