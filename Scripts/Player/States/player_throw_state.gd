extends PlayerState

@export var charge_time := 1.0
@export var max_power_level := 3

var item : Item
var charge_timer : float
var power_level := 0

@onready var progress : TextureProgressBar = $"../../SpringArm3D/Camera3D/Control/TextureProgressBar"


func enter() -> void :
	charge_timer = 0.0
	power_level = 0


func update(_delta) -> void :
	charge_timer += _delta
	if charge_timer >= charge_time and power_level < max_power_level:
		charge_timer = 0.0
		power_level += 1
		print(progress.max_value * (float(power_level) / float(max_power_level)))
		progress.value = progress.max_value * (float(power_level) / float(max_power_level))
		#var tween := create_tween().tween_property(
				#progress, "value",
				#progress.max_value * (power_level / max_power_level),
				#0.5).set_trans(Tween.TRANS_CUBIC)
	
	if Input.is_action_just_released("use"):
		progress.value = 0
		#var tween := create_tween().tween_property(
				#progress, "value",
				#0,
				#0.5).set_trans(Tween.TRANS_CUBIC)
		player.throw_item(power_level)
		transitioned.emit(self, "playeridle")
