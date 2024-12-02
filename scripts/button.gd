extends Node3D

@export var targets: Array[Node3D] = [] # Enforce that targets must be Node3D
@export var pressed_by_default: bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var button_state: bool = false
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	if pressed_by_default:
		button_state = true
		animation_player.play("toggle-on", -1, 10.0)
		
		# Send input to all targets
		for target in targets:
			if target and target.has_method("receive_input"):
				target.receive_input(button_state)

func _on_button_area_3d_area_entered(_area: Area3D) -> void:
	if cooldown_timer.is_stopped():
		cooldown_timer.start()
		if not animation_player.is_playing():
			# Toggle the button state
			button_state = not button_state
			animation_player.play("toggle-on" if button_state else "toggle-off")
			
			# Send input to all targets
			for target in targets:
				if target and target.has_method("receive_input"):
					target.receive_input(button_state)
