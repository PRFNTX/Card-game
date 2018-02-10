
extends Node2D

var GameNode
var me
var is_dummy = false

var watch_state=[
	'current_turn'
]

var local_state={'active':false}

var actions = 0
var gold = 2
var faeria = 0
var cards = 0
var hand_cards = 0 setget set_hand_cards
var int_to_land = ['land','lake','tree','hill','sand']
var lands = {'land':0,'lake':0,'tree':0,'hill':0,'sand':0}

var lbl_cards
var lbl_actions
var lbl_gold
var lbl_faeria

var Deck setget deck_init

func deck_init(val):
	if !is_dummy:
	
		Deck = val
		var cards = 0
		for card in val:
			curr_Deck.push_back(card)
			cards+=1
		setCards(cards)
	else:
		setCards(val)

var curr_Deck=[]
var Hand=[]
var hand_object
var Discard=[]

func _ready():
	pass

func onCreate(node,this):
	GameNode=node
	node.connect("TurnStart",self,"sig_TurnStart")
	node.connect("ActionPhase",self,"sig_ActionPhase")
	node.connect("TurnEnd",self,"sig_TurnEnd")
	node.connect("UpdateState",self,"state_update")
	lbl_cards = get_node('box/cards')
	lbl_actions = get_node('box/actions')
	lbl_gold = get_node('box/gold')
	lbl_faeria = get_node('box/faeria')
	lbl_hand = get_node('box/hand')
	me = this
	

###SIGNAL FUNCTIONS

func sig_TurnStart(turn):
	if ! is_dummy:
		if hand_object!=null:
			hand_object.update()

func sig_ActionPhase(turn):
	if local_state['active']:
		modActions(3)

func sig_TurnEnd(turn):
	setActions(0)


###STATE UPDATE
func state_update(newState,keys):
	for check in keys:
		if watch_state.has(check):
			self.call(check, newState[check])

###STATE UPDATE FUNCTIONS
func current_turn(newVal):
	local_state['active'] = (int(newVal)==int(me))
	

####VALUE CONTROLLS

func modLands(s_type,mod):
	lands[s_type]+=mod

func useAction(num):
	
	if actions>0:
		modActions(-1)
		return true
	else:
		return false

func setCards(val):
	print('set')
	
	cards=val
	lbl_cards.text=str(cards)

func modCards(mod):
	cards+=mod
	lbl_cards.text=str(cards)

func setActions(val):
	actions=val
	lbl_actions.text=str(actions)

func modActions(mod):
	actions+=mod
	lbl_actions.text=str(actions)

func modCoin(num):
	gold+=num
	lbl_gold.text=str(gold)
	
	#set displayed gold

func modFaeria(num):
	faeria+=num
	lbl_faeria.text=str(faeria)
	#set display

func drawCard():
	if !is_dummy:
		var card = floor(rand_range(0,curr_Deck.size()))
		Hand.push_back(curr_Deck[card])
		curr_Deck.remove(card)
		modCards(-1)
		hand_object.update()
	lbl_hand.text = Hand.size()
	

func discard_hand(card=-1):
	if !is_dummy:
		if card < 0:
			var discard = floor(rand_range(0,Hand.size()))
			Discard.push_back(Hand[discard])
			Hand.remove(discard)
		else:
			Discard.append(Hand[card])
			Hand.remove(card)
		hand_object.update()
	lbl_hand.text = str(Hand.size())

func discard_by_name(card):
	Hand.erase(card)
	lbl_hand.text = str(Hand.size())

func discard_deck():
	if !is_dummy:
		var card = floor(rand_range(0,curr_Deck.size()))
		Discard.push_back(curr_Deck[card])
		curr_Deck.remove(card)

func has_resource(c_gold,c_faeria,c_lands):
	#fuck you, me
	if !is_dummy:
		for land in c_lands.keys():
			if lands[int_to_land[land]]<c_lands[land]:
				return false
		if gold<c_gold or faeria<c_faeria:
			return false
		return true

func pay_costs(c_gold,c_faeria):
	modCoin(-1*c_gold)
	modFaeria(-1*c_faeria)
	return(true)

func set_hand_cards(val):
	hand_cards = val
	lbl_hand.text = str(val)
	
	
	
