extends Node2D
class_name NeedComponent

var hunger : int = 20
var MAX_HUNGER : int = 100
var DECAY : int = 5

@onready var hunger_bar: TextureProgressBar = %HungerBar

func _ready() -> void:
	hunger_bar.max_value = MAX_HUNGER
	hunger_bar.value = hunger
	
#feed
func feed(amount: int)-> void:
	hunger += amount
	hunger = clamp(hunger, 0, MAX_HUNGER)
	hunger_bar.value = hunger
	print(hunger)
#clean
#sleep


func _on_decay_timer_timeout() -> void:
	hunger -= DECAY
	hunger = clamp(hunger, 0, MAX_HUNGER)
	hunger_bar.value = hunger
