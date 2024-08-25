extends VehicleBody3D

const STEER_SPEED: float = 1.5
const STEER_LIMIT: float = 0.4
const BRAKE_STRENGTH: float = 2.0

@export var engine_force_value: float = 40.0

var previous_speed: float = linear_velocity.length()
var _steer_target: float = 0.0

#@onready var desired_engine_pitch: float = $EngineSound.pitch_scale
@onready var engine_sound: AudioStreamPlayer3D = $EngineSound
@onready var impact_sound: AudioStreamPlayer3D = $ImpactSound

func _physics_process(delta: float):
	#var fwd_mps := (linear_velocity * transform.basis).x

	self._steer_target = Input.get_axis(&"turn_right", &"turn_left") * STEER_LIMIT
	#self._steer_target *= STEER_LIMIT

	# Engine sound simulation (not realistic, as this car script has no notion of gear or engine RPM).
	var desired_engine_pitch: float = 0.05 + linear_velocity.length() / (engine_force_value * 0.5)
	# Change pitch smoothly to avoid abrupt change on collision.
	self.engine_sound.pitch_scale = lerpf(engine_sound.pitch_scale, desired_engine_pitch, 0.2)

	if abs(linear_velocity.length() - previous_speed) > 1.0:
		# Sudden velocity change, likely due to a collision. Play an impact sound to give audible feedback,
		# and vibrate for haptic feedback.
		self.impact_sound.play()

	if Input.is_action_pressed(&"accelerate"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			self.engine_force = clampf(engine_force_value * 5.0 / speed, 0.0, 100.0)
		else:
			self.engine_force = engine_force_value
			
	else:
		engine_force = 0.0

	if Input.is_action_pressed(&"reverse"):
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(engine_force_value * BRAKE_STRENGTH * 5.0 / speed, 0.0, 100.0)
		else:
			engine_force = -engine_force_value * BRAKE_STRENGTH

		# Apply analog brake factor for more subtle braking if not fully holding down the trigger.
		engine_force *= Input.get_action_strength(&"reverse")

	steering = move_toward(steering, _steer_target, STEER_SPEED * delta)

	previous_speed = linear_velocity.length()
