extends Label3D

@export var initial_size := 16
@export var final_size := 32
@export var height := 2.0
@export var displacement := 3.0
@export var lifetime := 1.0

@onready var lifetime_timer = $Lifetime


func _ready():
	lifetime_timer.start(lifetime)
	font_size = initial_size
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "font_size", final_size, lifetime / 4)
	tween.set_ease(Tween.EASE_IN).tween_property(self, "font_size", 0, lifetime - (lifetime / 4))

	await get_tree().process_frame

	var rand := Vector3(randf_range(-1, 1) * displacement, randf_range(0.5, 1) * height, randf_range(-1, 1) * displacement) + global_position
	var pos_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel()
	pos_tween.tween_property(self, "global_position:x", rand.x, lifetime)
	pos_tween.tween_property(self, "global_position:z", rand.z, lifetime)

	var height_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	height_tween.tween_property(self, "global_position:y", rand.y, lifetime / 2)
	height_tween.set_ease(Tween.EASE_IN).tween_property(self, "global_position:y", global_position.y - rand.y, lifetime / 2)



func _on_lifetime_timeout():
	queue_free()
