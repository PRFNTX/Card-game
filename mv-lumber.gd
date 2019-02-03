extends Node


export(String) var ab_name = ""
export(String) var ab_description = ""

export(int) var value = 2
export(int, 'gold', 'faeria', 'actions', 'cards') var resource = 0
export(int, "empty","orb","land","lake","tree","hill","sand","well", "any") var type = 5
export(int, 'friendly', 'enemy', 'any') var player = 0

var Game
var entity
var val

func init(_entity):
	entity = _entity
	Game = entity.Game
	
func activate(_game, _entity, hexNum):
	var hexEntity = Game.get_hex_by_id(hexNum)
	if hexEntity.stateLocal.hexType == type or type == 8:
		if (
			player == 2
			or (hexEntity.stateLocal.hex_owner == entity.Owner and player==0)
			or (hexEntity.stateLocal.hex_owner != entity.Owner and player==1)
		):
			if type == 0:
				Game.players[entity.Owner].modCoin(value)
			elif type==1:
				Game.players[entity.Owner].modFaeria(value)
			elif type==2:
				Game.players[entity.Owner].modActions(value)
			elif type==3:
				for i in value:
					Game.players[entity.Owner].drawCard()
	Game.update_lands_owned()
	