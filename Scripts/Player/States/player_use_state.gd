extends PlayerState


func enter():
	player.use_tool()
	#player.animation_player.play("use")
	pass


func update(_delta):
	super(_delta)
	
	#if not player.animation_player.is_playing():
		#transitioned.emit(self, "playeridle")
		
	transitioned.emit(self, "playeridle")
