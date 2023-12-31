extends CharacterBody3D

@export var start_speed := 2.0
@export var max_speed := 25.0
@export var spin_speed := 12.0
@export var max_spin_speed := 36.0
@export var speed_time := 1.0
@export var pierce := 0
@export var lifetime := 15.0

var speed := 0.0
var tween : Tween

@onready var hurt_area_comp : HurtAreaComponent = $HurtAreaComponent
@onready var model : GeometryInstance3D = $Model


func _ready():
	speed = start_speed
	model.spin_speed = spin_speed
	hurt_area_comp.hit.connect(_on_hurt)
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_property(self, "speed", max_speed, speed_time)
	tween.tween_property(model, "spin_speed", max_spin_speed, speed_time)

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(_delta):
	velocity = Vector3.FORWARD.rotated(Vector3.UP, rotation.y) * speed
	move_and_slide()
	if is_on_wall():
		queue_free()


func _on_hurt(_area):
	if pierce <= 0:
		queue_free()
	pierce -= 1
