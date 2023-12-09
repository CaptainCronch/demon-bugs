extends Node3D


func _on_body_entered(_body):
	$GPUParticles3D.restart()
	$AudioStreamPlayer3D.play()
