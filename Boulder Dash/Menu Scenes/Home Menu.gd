extends Control

#export var NextScene: PackedScene
onready var palettes = {"interactive": [0, 0, 0, 0, 0, 0], "ground": [0, 0], "solid": [9, 0, 0]}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_Button_button_up():
	get_parent().loadLevel()
	queue_free()

func _on_Exit_Button_button_up():
	get_tree().quit()


func _on_Lv_Select_Button_button_up():
	var lvlSelect = load("res://Menu Scenes/Level Select.tscn").instance()
	get_tree().get_current_scene().add_child(lvlSelect)
