extends PlayerItemState

@export var charge_time := 0.2
@export var max_power_level := 3
@export var drop_delay := 0.2

var item : Item
var charge_timer : float
var power_level := 0
var thrown := false

@onready var progress : TextureProgressBar = $"../../SpringArm3D/Camera3D/Control/TextureProgressBar"
@onready var drop_timer : Timer = $DropDelay


func enter() -> void :
	charge_timer = 0.0
	power_level = 0
	thrown = false


func update(_delta) -> void :
	if thrown: return

	charge_timer += _delta
	if charge_timer >= charge_time and power_level < max_power_level:
		charge_timer = 0.0
		power_level += 1
		progress.value = progress.max_value * (float(power_level) / float(max_power_level))
		#var tween := create_tween().tween_property(
				#progress, "value",
				#progress.max_value * (power_level / max_power_level),
				#0.5).set_trans(Tween.TRANS_CUBIC)

	if Input.is_action_just_released("drop"):
		thrown = true
		progress.value = 0
		#var tween := create_tween().tween_property(
				#progress, "value",
				#0,
				#0.5).set_trans(Tween.TRANS_CUBIC)
		player.throw_item(power_level)
		drop_timer.start(drop_delay)


func exit():
	drop_timer.stop()


func _on_drop_delay_timeout():
	transitioned.emit(self, "hold")
