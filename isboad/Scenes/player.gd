extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var neck: Node3D = $neck

const MOUSE_SENS:float = 0.01

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion:Vector2 = event.relative
		rotate_y(-(mouse_motion.x * MOUSE_SENS))
		neck.rotate_x(-(mouse_motion.y * MOUSE_SENS))
		neck.rotation.x = deg_to_rad(clamp(rad_to_deg(neck.rotation.x), -90, 50))

enum {idle, run}
var curAnim = idle 

@onready var anim_tree: AnimationTree = $MeshInstance3D/Sprite3D/zombie/AnimationTree

@export var blend_speed = 15

# FIX: Force run_val to be a float so lerp() works perfectly
var run_val: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Apply gravity if in the air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Get input direction and handle movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			curAnim = run
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			curAnim = idle # Set back to idle when stopping

	# 4. Apply movement ONCE per frame
	move_and_slide()
	
	# 5. Process animations and push values to the AnimationTree
	handle_animation(delta)
	update_tree()

func handle_animation(delta):
	match curAnim:
		idle:
			run_val = lerp(run_val, 0.0, blend_speed * delta)
		run:
			# FIX: Blend towards 1.0 (fully running) instead of 0.0 (idle)
			run_val = lerp(run_val, 1.0, blend_speed * delta)

func update_tree():
	# FIX: Fixed typo "blend_anount" to "blend_amount"
	anim_tree["parameters/run/blend_amount"] = run_val
