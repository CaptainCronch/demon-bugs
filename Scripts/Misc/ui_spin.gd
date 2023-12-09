extends TextureProgressBar

@export var enabled := true
@export var spin_speed := 2


func _process(_delta):
	if not enabled: return
	rotation = wrapf(rotation + (spin_speed * _delta), -PI, PI)
	#radial_initial_angle = wrapf(radial_initial_angle + (spin_speed * _delta), -360, 360)
	#radial_fill_degrees = wrapf(radial_fill_degrees + (spin_speed * _delta), -360, 360)
