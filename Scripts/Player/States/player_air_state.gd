extends PlayerState


func update(_delta):
	if player.velocity.y >= peak_range: player.gravity = base_gravity
	elif player.velocity.y <= -peak_range: player.gravity = fall_gravity
	else: player.gravity = peak_gravity # dfferent gravities applied based on y velocity
	
	player.velocity.y -= player.gravity * _delta # gravity
	player.velocity.y = max(player.velocity.y, max_fall_speed) # max fall speed
	
	if player.is_on_floor():
		player.coyote_timer.start(coyote_time) # starts letting you jump
	
	if Input.is_action_just_pressed("jump"):
		player.buffer_timer.start(buffer_time) # waits until you touch the ground to jump
	
	if not player.coyote_timer.is_stopped() and not player.buffer_timer.is_stopped():
		player.velocity.y = jump_force
		player.buffer_timer.stop()
		player.coyote_timer.stop()
	
	if not Input.is_action_pressed("jump") and player.velocity.y > jump_force * 0.25:
		player.velocity.y = jump_force * 0.25 # jump cut when you let go of jump
