extends Area3D

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	# Connect the body_entered signal via code, or do it via the Node dock in the editor
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Play the 3D sound on impact
	if not audio_player.playing:
		audio_player.play()
