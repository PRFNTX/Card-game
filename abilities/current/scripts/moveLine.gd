extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var distance = 2
export(int,"None","Flying","Aquatic") var medium = 0
export(int,'Charge', 'jump') var method = 0

const MEDIUM_NONE = 0
const MEDIUM_FLYING = 1
const MEDIUM_AQUATIC = 2

const METHOD_CHARGE = 0
const METHOD_JUMP = 1

var entity
var Game
func init(_entity):
	entity = _entity
	Game = entity.Game

var val

func start_action(entity):
	activate(entity.Game,entity,null)

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	val=_val
	Game.delegate_action(entity.Hex.id,'Movement/moveLine')

func verify_costs():
	return entity.get_energy()>=1

func targeting():
	#first ring
	#second ring with unique adjacency to first
	#third ring with unique adjacency to second
	var center_hex = Game.get_hex_by_id(entity.Hex.id)
	var rings = []
	rings.append(center_hex.adjacent)
	for i in range(2,distance+1):
		var prev_ring = ring(center_hex,i)
		var curr_ring = []
		for hex in prev_ring:
			for adj in hex.adjacent:
				curr_ring.append(adj)
		var final_ring = []
		for hex in curr_ring:
			if curr_ring.find(hex)==curr_ring.find_last(hex) and (not hex.has_unit() or method==1):
				final_ring.append(hex)
		rings.append(final_ring)
	rings.append([center_hex])
	for ring in rings:
		for hex in ring:
			if (hex.hex_is_empty_or_self(center_hex.id)) and ((hex.hexType.child.moveLand and medium==0) or (hex.hexType.child.moveAir and medium==1) or (hex.hexType.child.moveWater and medium==2)):
				hex.setState({'cover':hex.targetOther , 'target' :true})

func ring(hex,n):
	if n == 0:
		return hex
	if n==1:
		return hex.adjacent
	var adj=[hex,hex.adjacent]
	
	for i in range(2,n):
		var new = []
		for hex in adj[i-1]:
			for ad in hex.adjacent:
				new.append(ad)
		var rng = []
		for j in range(1,i):
			for hex in new:
				if adj[j].has(hex) or adj[0]==hex:
					new.erase(hex)
		adj.append(new)
	return adj[n-1]


func complete(target, set_state=null):
	## REMOTE HAS NO ACCESS TO GAME OR ENTITY
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
	
	
	var hex_target = Game.get_hex_by_id(target)
	
	if local:
		#Game.send_action('dee',45-target,{'delegate_node':str(get_path()).replace("/","~")})
		#Game.send_action('delegate',45-target,{'delegate_node':'Movement/moveLine','delegate_id':45-entity.Hex.id})
		Game.send_action('miscMove',45-target,{'active_unit':45-entity.Hex.id})
	
	entity.on_move(hex_target.get_node('hexEntity'))
	entity.use_energy(1)
	entity.Hex=hex_target
	Game.setState({'delegate_id':target})
	
	
	if Game.check_valid_action(entity.Unit.get_action_name('Attack')) and local and entity.Unit.current_health>0:
		Game.setState({'active_unit':target})
		Game.actionReady=true
		entity.Unit.start_attack(Game)
	else:
		return true

func cancel_action():
	pass


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
