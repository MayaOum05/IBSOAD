extends Node3D

var correct_order = ["Star", "Heart", "Diamond"]
var current_index = 0
var puzzle_active = false

@onready var memory_timer = $MemoryTimer
@onready var memory_objects = $MemoryObjects.get_children()


func start_memory_sequence():
	puzzle_active = false
	current_index = 0

	for object in memory_objects:
		object.visible = true

	memory_timer.start()


func _on_memory_timer_timeout():
	print("TIMER FINISHED!")

	puzzle_active = true

	for object in memory_objects:
		object.visible = false

	print("Moving Star...")

	$MemoryObjects/Star.position = Vector3(0, 1, 0)
	$MemoryObjects/Star.visible = true

	print("Star visible: ", $MemoryObjects/Star.visible)
	print("Star position: ", $MemoryObjects/Star.position)

func collect_object(object_name):
	if not puzzle_active:
		return

	var expected_object = correct_order[current_index]

	if object_name == expected_object:
		print("Correct: ", object_name)

		current_index += 1

		if current_index >= correct_order.size():
			puzzle_complete()
	else:
		puzzle_failed()


func puzzle_failed():
	print("Wrong order! Try again.")

	puzzle_active = false
	current_index = 0

	await get_tree().create_timer(2.0).timeout

	start_memory_sequence()


func puzzle_complete():
	print("HIPPOCAMPUS PUZZLE COMPLETE!")

	puzzle_active = false
