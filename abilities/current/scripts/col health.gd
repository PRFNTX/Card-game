extends Node

export(int,'health') var gain_type = 0
export(bool) var value_by_faeria = false
export(int) var value = 1
export(bool) var instead = false
export(int) var lose_collect_at = 0

func activate(Game, entity, by, val):
	var gain = val
	if not value_by_faeria:
		gain = value
	if gain_type==0:
		entity.life_change(1)
		if lose_collect_at > 0 and entity.current_health >= lose_collect_at:
			entity.Unit.collect = false