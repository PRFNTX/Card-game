extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var gain = 1

func activate(Game, entity, target):
	entity.Unit.life_change(gain)