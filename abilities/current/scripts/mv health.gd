extends Node

export(int) var gain = 1

func activate(Game, entity, target):
	entity.Unit.life_change(gain)