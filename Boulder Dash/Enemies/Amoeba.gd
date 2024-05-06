extends StaticBody2D

var randomInt
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	randomInt = random.randi_range(0, 3)
	rotation_degrees = randomInt*90

#func _process(_delta):
#	pass
