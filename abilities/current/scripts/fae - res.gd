extends Node

export(int,'Cards','Actions','Energy','Gold', 'faeria') var gain_type = 1
export(bool) var value_by_faeria = true
export(int) var value = 0
export(bool) var instead = false

func activate(Game, entity, by, val):
	var gain = val
	if not value_by_faeria:
		gain = value
	if gain_type==0:
		for i in range(0,gain):
			Game.players[Game.get_hex_by_id(by).get_unit().Owner].drawCard()
	if gain_type==1:
		Game.players[Game.get_hex_by_id(by).get_unit().Owner].modActions(gain)
	if gain_type==2:
		for i in range(0,gain):
			Game.get_hex_by_id(by).get_unit().add_one_energy()
	if gain_type==3:
		Game.players[Game.get_hex_by_id(by).get_unit().Owner].modCoin(gain)
	if gain_type==4:
		Game.players[Game.get_hex_by_id(by).get_unit().Owner].modFaeria(value)
	if instead:
		Game.players[Game.get_hex_by_id(by).get_unit().Owner].modFaeria(-1*val)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
