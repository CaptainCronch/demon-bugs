extends Node
class_name State

signal transitioned(current_state, next_state)

var state_machine : StateMachine


func enter() -> void :
	pass


func exit() -> void :
	pass


func update(_delta: float) -> void :
	pass


func physics_update(_delta: float) -> void :
	pass
