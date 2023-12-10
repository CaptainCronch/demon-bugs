extends BugState

@export var anticipation_speed := 0.5
@export var anticipation_duration := 0.5
@export var health_comp : HealthComponent

var active := false

@onready var anticipation_timer : Timer = $AnticipationTimer


func _ready():
	health_comp.damage_taken.connect(_on_damage_taken)


func enter():
	active = true
	plat_comp.move_speed = anticipation_speed
	anticipation_timer.start(anticipation_duration)


func physics_update(_delta):
	if anticipation_timer.is_stopped():
		transitioned.emit(self, "attack")


func exit():
	active = false


func _on_damage_taken(_attack) -> void :
	if not active: return
	anticipation_timer.stop()
	transitioned.emit(self, "chase")
