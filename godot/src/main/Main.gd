extends Node2D
const Boid = preload("res://src/boid/Boid.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in range(150):
		self.add_child(Boid.instance())
	

