extends BugState

@export var wander_speed := 2.0
@export var walk_time := 2.0

@onready var walk_timer : Timer = $Walk



func enter():
	plat_comp.move_speed = wander_speed
	plat_comp.move_dir = Vector2((randi_range(0, 1) * 2) - 1, (randi_range(0, 1) * 2) - 1).normalized()
	walk_timer.start(randfn(1, random_spread) * walk_time)


func update(_delta):
	if walk_timer.is_stopped():
		transitioned.emit(self, "wait")
