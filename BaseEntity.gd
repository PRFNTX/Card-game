extends Node2D

export(int) var max_faeria = 0
export(int) var max_energy = 1
export(int) var base_attack = 1
export(int) var base_health = 1
export(int) var base_val = 1

export(Color,RGB) var COLOR_GREATER
export(Color,RGB) var COLOR_EQUAL
export(Color,RGB) var COLOR_LESS

export(Color,RGB) var ENERGY_ACTIVE
export(Color,RGB) var ENERGY_INACTIVE

var current_faeria = 0 setget set_faeria
var current_energy = 0 setget set_energy
var current_attack = 0 setget set_attack
var current_health = 0 setget set_health
var current_val = 0 setget set_val

var mod_att = {} 

var intermediate_attack

func set_mod_att(val):
	mod_att[val.source]=val.effect


func set_attack(val):
	intermediate_attack = val
	for modifier in mod_att:
		current_attack += modifier
	get_node('Unit/A').text=str(current_attack)
	modulate_colors()

func set_health(val):
	current_health = val
	get_node('Unit/H').text=str(current_health)
	modulate_colors()

func set_val(val):
	current_val = val
	get_node('Building/Val').text=str(current_val)
	modulate_colors()

func set_energy(val):
	current_energy=val
	var children = $Energy.get_children()
	for symb in children.size():
		if symb<current_energy:
			children[symb].show()
		else:
			children[symb].hide()

func add_one_energy():
	current_energy+=1
	$Energy.get_children()[current_energy-1].show()

func set_faeria(val):
	current_faeria = val
	var children = $Faeria.get_children()
	for symb in children.size():
		if symb<current_faeria:
			children[symb].show()
		else:
			children[symb].hide()

func add_one_faeria():
	if current_faeria<max_faeria:
		current_faeria+=1
		$Faeria.get_children()[current_faeria-1].show()


export(bool) var is_unit = 0
export(bool) var is_building=0
export(bool) var is_event=0

export(bool) var move = 0
export(bool) var charge = 0
export(bool) var jump = 0
export(bool) var aquatic = 0
export(bool) var flying = 0
export(bool) var conquest = 0
export(bool) var convoke = 0
export(bool) var radiate = 0
export(bool) var auto_collect = 0

export(bool) var collect = 0
export(bool) var attack = 0
export(bool) var abilities = 0

export(bool) var on_play = 0
export(bool) var on_production = 0
export(bool) var on_attack = 0
export(bool) var on_move = 0
export(bool) var on_collect = 0
export(bool) var on_damage = 0
export(bool) var on_death = 0
export(bool) var on_clock = 0
export(bool) var on_action = 0
export(bool) var on_turn_end = 0

export(Texture) var frame_alt = null

func _ready():
	if frame_alt != null:
		$Frame.texture = frame_alt
	if is_unit:
		get_node('Building/Val').hide()
		get_node('Unit/A').show()
		get_node('Unit/div').show()
		get_node('Unit/H').show()
	elif is_building:
		get_node('Unit/A').hide()
		get_node('Unit/div').hide()
		get_node('Unit/H').hide()
		get_node('Building/Val').show()
	else:
		get_node('Unit/A').hide()
		get_node('Unit/H').hide()
		get_node('Unit/div').hide()
		get_node('Building/Val').hide()
	
	set_energy(0)
	set_health(base_health)
	set_attack(base_attack)
	set_val(base_val)
	
	

func turn_start(stun):
	print(stun)
	if current_energy<max_energy and !stun:
		add_one_energy()
	if on_production:
		production()

func start_attack(Game):
	if $Attack.get_child_count()>0:
		$Attack.get_children()[0].start_action(Game)

func on_select(Game,hex):
	if $Movement.get_child_count()>0:
		$Movement.get_children()[0].start_action(Game)

func play():
	for effectNode in $on_play.get_children():
		return effectNode.activate(get_parent().Game,get_parent(),"")
		

func production():
	if on_production:
		for effectNode in $on_production.get_children():
			effectNode.activate(get_parent().Game,get_parent(),"")

func action():
	if on_action:
		for effectNode in $on_production.get_children():
			effectNode.activate(get_parent().Game,get_parent(),"") ##this one is wrong

func on_turn_end():
	if on_turn_end:
		for effectNode in $on_production.get_children():
			effectNode.activate(get_parent().Game,get_parent(),"")

func attack(target):
	for effectNode in $on_attack.get_children():
		effectNode.activate(get_parent().Game,get_parent(), target.id)

func move(target):
	for effectNode in $on_move.get_children():
		effectNode.activate(get_parent().Game,get_parent(), target.id )

func collect():
	for effectNode in $on_collect.get_children():
		effectNode.activate(get_parent().Game,get_parent(),"")

func damage(in_damage):
	var dmg = in_damage
	for effectNode in $on_damage.get_children():
		dmg = effectNode.activate(get_parent().Game,get_parent(),dmg)
	return dmg

func death():
	for effectNode in $on_death.get_children():
		effectNode.activate(get_parent().Game,get_parent(),null)

func get_actions():
	var ret = {}
	#for move in $Movement.get_children():
	#	ret[move.get_name()]=move
	#for ability in $Abilities.get_children():
#		ret[ability.description]=ability
	
	return(ret)

func clock(time):
	for effectNode in $on_clock.get_children():
		effectNode.activate(get_parent().Game,get_parent(),time)

func get_action_name(type):
	if get_node(type).get_child_count()>0:
		return get_node(type).get_children()[0].get_action_type()
	else:
		return ""


func modulate_colors():
	if current_attack > base_attack:
		get_node("Unit/A").modulate = COLOR_GREATER
	elif current_attack == base_attack:
		get_node("Unit/A").modulate = COLOR_EQUAL
	elif current_attack < base_attack:
		get_node("Unit/A").modulate = COLOR_LESS
	
	if current_health > base_health:
		get_node("Unit/H").modulate = COLOR_GREATER
	elif current_health == base_health:
		get_node("Unit/H").modulate = COLOR_EQUAL
	elif current_health < base_health:
		get_node("Unit/H").modulate = COLOR_LESS
	
	if current_val > base_val:
		get_node("Building/Val").modulate = COLOR_GREATER
	elif current_val == base_val:
		get_node("Building/Val").modulate = COLOR_EQUAL
	elif current_val < base_val:
		get_node("Building/Val").modulate = COLOR_LESS
