extends Area3D

@export var object_name := "Star"

var player_nearby = false


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		print("Player is near ", object_name)


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false


func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("pickup"):
		var hippocampus = get_parent().get_parent()
		hippocampus.collect_object(object_name, self)
