extends StaticBody2D

const winSound = preload("res://Audio/win.mp3")

func _ready():
	pass # Replace with function body.

func open():
	$AnimationPlayer.play("Open")

func win():
	get_parent().get_node("Player").visible = false
	$AnimationPlayer.play("Stay Open")
	$AudioStreamPlayer2D.stream = winSound
	$AudioStreamPlayer2D.play()
	


func _on_AudioStreamPlayer2D_finished():
	get_node("/root/World").unloadLevel(1)
