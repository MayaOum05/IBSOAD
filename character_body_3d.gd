extends CharacterBody3D

var inventory = []

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var nearby_object = null

@onready var pickup_area = $PickupArea


func _ready() -> void:
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	pickup_area.area_exited.connect(_on_pickup_area_exited)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_pickup_area_entered(area):
	print("PICKUP AREA DETECTED: ", area.name)

	if area.is_in_group("pickup"):
		nearby_object = area
		print("PICKUP OBJECT: ", area.name)

func _on_pickup_area_exited(area):
	if area == nearby_object:
		nearby_object = null


func _process(_delta):
	if Input.is_action_just_pressed("pickup") and nearby_object:
		print("Picked up: ", nearby_object.name)

		inventory.append(nearby_object.name)

		print("Inventory: ", inventory)

		# Tell the Hippocampus about the pickup
		var hippocampus = get_parent()

		if hippocampus.has_method("collect_object"):
			hippocampus.collect_object(nearby_object.name, nearby_object)

		nearby_object.visible = false
		nearby_object = null
