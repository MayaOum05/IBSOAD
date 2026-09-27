extends AnimationPlayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_forward"):
		print("Move action started via event!")
