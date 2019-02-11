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
	var adj_ring = center_hex.adjacent
	if method == METHOD_JUMP:
		var jump_ring = get_jump_ring(center_hex)
		for hex in jump_ring:
			if (hex.hex_is_empty_or_self(center_hex.id)) and ((hex.hexType.child.moveLand and medium==0) or (hex.hexType.child.moveAir and medium==1) or (hex.hexType.child.moveWater and medium==2)):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover':Color(0,0,0,0) , 'target':false})
		return
	var rings = []
	var final_finger = {}
	for hex in adj_ring:
		final_finger[hex] = [hex]
	var final_hexes = []
	rings.append(center_hex.adjacent)
	for i in range(1,distance):
		var prev_ring = rings[i-1]
		var curr_ring = []
		var curr_finger = {}
		var negate_ring = []
		#the last hex in each ring becomes the start of the next
		for fing in final_finger.values():
				curr_finger[fing.back()] = [fing.back()]
		#for each hex in the previous ring
		for hex in prev_ring:
			#get the list of adjacent hexes
			for adj in hex.adjacent:
				#if its not the center hex, isnt in the previous ring, isn't in current ring, and hasnt been removed from current ring
				if not adj == center_hex and not prev_ring.has(adj) and not curr_ring.has(adj) and not negate_ring.has(adj):
					#add it to current ring and the finger for the hex its adjacent to
					curr_ring.append(adj)
					if curr_finger.keys().has(hex):
						curr_finger[hex].append(adj)
				#otherwise if current ring has it and negate ring doesnt
				elif curr_ring.has(adj) and not negate_ring.has(adj):
					#add it to negate ring and remove it from all fingers
					for set in curr_finger.values():
						set.erase(adj)
					negate_ring.append(adj)
		for ray in final_finger.values():
			var joint = ray.pop_back()
			for one in curr_finger[joint]:
				ray.append(one)
		var final_ring = []
		for direction in curr_finger.values():
			var negated = false
			for hex in direction:
				if not negated and (hex.stateLocal.hex_type != 0 or ([0, 3].has(hex.stateLocal.hex_type) and medium == MEDIUM_AQUATIC) or medium == MEDIUM_FLYING):
					final_hexes.append(hex)
		rings.append(curr_ring)
	rings.append([center_hex])
	for finger in final_finger.values():
		var terminate = false
		for hex in finger:
			var blockedByLand = (hex.stateLocal.hex_type == 0 and medium==MEDIUM_NONE) or ([2,4,5,6].has(hex.stateLocal.hex_type) and medium == MEDIUM_AQUATIC)
			var blockedByUnit = hex.has_unit() and (medium==MEDIUM_NONE or medium == MEDIUM_AQUATIC)
			terminate = blockedByUnit or blockedByLand or terminate
			if not terminate and (hex.hex_is_empty_or_self(center_hex.id)) and ((hex.hexType.child.moveLand and medium==0) or (hex.hexType.child.moveAir and medium==1) or (hex.hexType.child.moveWater and medium==2)):
				hex.setState({'cover':hex.targetOther , 'target' :true})
			else:
				hex.setState({'cover': Color(0,0,0,0) , 'target': false})
	center_hex.setState({'cover':center_hex.targetOther, 'target': true})
	return

func get_jump_ring(center):
	var ring = center.adjacent
	var jump_ring = []
	for hex in ring:
		for hex_adj in hex.adjacent:
			if not ring.has(hex_adj) and not jump_ring.has(hex_adj):
				jump_ring.append(hex_adj)
	return jump_ring

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
	var start_id
	if local:
		start_id = Game.get_state().delegate_id
	
	entity.on_move(hex_target.get_node('hexEntity'))
	entity.use_energy(1)
	entity.Hex=hex_target
	Game.setState({'delegate_id':target,'active_unit':target})
	if local:
		Game.send_action('miscMove',45-target,{'active_unit':45-start_id})
		if Game.check_valid_action(entity.Unit.get_action_name('Attack')) and local and entity.Unit.current_health>0:
			Game.actionReady=true
			entity.Unit.start_attack(Game)
			return false
		else:
			return true
	else:
		Game.actionDone()

func cancel_action():
	pass


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
