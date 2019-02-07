extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int,'Cards','Actions','Energy','Gold', 'faeria') var gain_type = 1
export(bool) var value_by_faeria = true
export(int) var value = 0
export(bool) var instead = false

func activate(Game, entity, val):
	var unit_owner = Game.players[entity.Owner]
	var gain = val
	if not value_by_faeria:
		gain = value
	if gain_type==0:
		for i in range(0,gain):
			unit_owner.drawCard()
	if gain_type==1:
		unit_owner.modActions(gain)
	if gain_type==2:
		for i in range(0,gain):
			entity.add_one_energy()
	if gain_type==3:
		unit_owner.modCoin(gain)
	if gain_type==4:
		unit_owner.modFaeria(value)
	if instead:
		unit_owner.modFaeria(-1*val)
