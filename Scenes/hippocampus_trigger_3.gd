extends Area3D

func _on_body_entered(body: Node3D) -> void:
	# Check if the body that entered is the Player
	if body.name == "Player":
		trigger_event()

func trigger_event() -> void:
	print("Player entered final trigger")
