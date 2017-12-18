
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
class Player:
	var PlayerState
	var Gold
	func Set_State(new_state):
		if (new_state==0):
			PlayerState=StateBeginTurn.new()
		if (new_state==1):
			PlayerState=StateActionPhase.new()
		if new_state==2:
			PlayerState=StateTarget.new()
		if new_state==3:
			PlayerState=StateEndTurn.new()
		if new_state==4:
			PlayerState=StateWait.new()
	func init():
		print("test")
		Gold=3
	
	func exit():
		pass


######     ACTION PHASE    ################################################

class StateActionPhase:
	#gain action points and gold
	#accept action inputs
	var ActionPoints
	func init():
		ActionPoints
		ActionPhaseStart.Broadcast()
		
	
	func exit():
		pass

##########  TARGETING   ##############################################

class StateTarget:
	#send in 
	class test:
		func init():
			pass
		
	func init():
		pass
	
	func exit():
		pass

############# BEGIN TURN #########################################

class StateBeginTurn:
	#add energy
	#advance clock
	# broadcast begin turn
	
	func init(for_player):
		for_player.Gold+=1
		TurnStart.Broadcast(for_player)
		exit()
		
	
	func exit():
		LocalPlayer.Set_State(STATE_ACTION_PHASE)


########### END TURN ############################################
class StateEndTurn:
	func init():
		pass
	
	func exit():
		pass

########## WAITING  #############################################
class StateWait:
	func init():
		pass
	
	func exit():
		pass

const STATE_BEGIN_TURN=0
const STATE_ACTION_PHASE=1
const STATE_TARGET_SELECT=2
const STATE_END_TURN=3
const STATE_WAIT=4

signal TurnStart
signal ActionPhaseStart
signal TurnEnd


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var LocalPlayer= Player.new()
	var RemotePlayer=Player.new()
	
	
	


