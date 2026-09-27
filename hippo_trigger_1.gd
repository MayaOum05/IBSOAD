extends Area3D

@onready var narrator = $AudioStreamPlayer3D
@onready var hippocampus = get_parent()

var triggered = false


func _on_body_entered(body: Node3D) -> void:
	print("Something entered trigger: ", body.name)

	if body.name == "Player" and not triggered:
		triggered = true
		trigger_event()


func trigger_event() -> void:
	narrator.play()
	hippocampus.start_memory_sequence()
