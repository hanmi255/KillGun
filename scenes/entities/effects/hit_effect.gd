extends Node2D

@onready var part = $GPUParticles2D

func _ready() -> void:
	part.restart()
	await part.finished
	queue_free()
