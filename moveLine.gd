extends Node


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(int) var distance = 2
export(int,"None","Flying","Aquatic") var medium = 0
export(int,'Charge', 'jump') var method = 0


var entity
var Game
var val

func start_action(entity):
	activate(entity.Game,entity,null)

func activate(_Game, _entity, _val):
	Game = _Game
	entity = _entity
	val=_val
	var del_path = get_path()
	Game.delegate_action(entity.Hex.id,del_path)



func targeting():
	#first ring
	#second ring with unique adjacency to first
	#third ring with unique adjacency to second
	var center_hex = Game.get_hex_by_id(entity.Hex.id)
	var rings = []
	rings.append(center_hex.adjacent)
	for i in range(2,distance+1):
		var curr_ring = []
		for hex in rings[i-2]:
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
			print(hex.hex_is_empty_or_self(center_hex.id))
			print((hex.hexType.child.moveLand and medium==0))
			print((hex.hexType.child.moveAir and medium==1))
			print(hex.hexType.child.moveWater and medium==2)
			if (hex.hex_is_empty_or_self(center_hex.id)) and ((hex.hexType.child.moveLand and medium==0) or (hex.hexType.child.moveAir and medium==1) or (hex.hexType.child.moveWater and medium==2)):
				hex.setState({'cover':hex.targetOther , 'target' :true})
	


func complete(target, set_state=null):
	
	var local = true
	var state = Game.get_state()
	if not set_state==null:
		state=set_state
		local= false
		
	var hex_target = Game.get_hex_by_id(target)
	entity.on_move(hex_target.get_node('hexEntity'))
	entity.Hex=hex_target
	entity.use_energy()
	if local:
		#Game.send_action('dee',45-target,{'delegate_node':str(get_path()).replace("/","~")})
		Game.send_action('delegate',45-target,{'delegate_node':'Movement/moveLine','delegate_id':45-entity.Hex.id})
	
	
	if Game.check_valid_action(entity.Unit.get_action_name('Attack')):
		Game.setState({'active_unit':entity.Hex.id})
		Game.actionReady=true
		entity.Unit.start_attack(Game)
	else:
		return true
	


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
