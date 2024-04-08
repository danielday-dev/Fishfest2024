extends CharacterBody3D

@export var movementSpeed : float = 2.0;
@export var mouseSensitivity : float = 0.5;
@export var nonForwardMovementFactor : float = 0.4;

@export var pingMaterial : ShaderMaterial;
@export var maxPingCooldown : float = 10;
@export var pingSpeed : float = 1;
var pingCooldown : float;
var pingDistance : float;

func _ready():
	# Initialize ping.
	pingCooldown = 0.0;
	pingDistance = 0.0;
	
func _process(delta):
	# Handle ping.
	processPing(delta);
	
var cameraOffset : Vector2 = Vector2.ZERO;
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		cameraOffset += event.relative;

func _physics_process(delta):
	if (Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		return;
	
	# Handle camera.	
	rotation.y += -cameraOffset.x * delta * mouseSensitivity;
	rotation.x += -cameraOffset.y * delta * mouseSensitivity;
	rotation.x = clamp(rotation.x, -1.6, 1.6);
	cameraOffset = Vector2.ZERO

	# Get input.
	var playerMovement : Vector3 = Vector3(
		Input.get_axis("Player_Movement_Left", "Player_Movement_Right"),
		Input.get_axis("Player_Movement_Down", "Player_Movement_Up"),
		Input.get_axis("Player_Movement_Backward", "Player_Movement_Forward")
	);
	
	# Calculate angle directions.
	var forward : Vector3 = Vector3(
		-sin(rotation.y) * cos(rotation.x),
		sin(rotation.x),
		-cos(rotation.y) * cos(rotation.x)
	);
	var right : Vector3 = Vector3(
		cos(rotation.y),
		0,
		-sin(rotation.y)
	);
	var upX : float = rotation.x + (PI * 0.5);
	var up : Vector3 = Vector3(
		-sin(rotation.y) * cos(upX),
		sin(upX),
		-cos(rotation.y) * cos(upX)
	);
	
	# Update velocity.
	velocity = (
		(forward * playerMovement.z) + 
		(up * playerMovement.y * nonForwardMovementFactor) + 
		(right * playerMovement.x * nonForwardMovementFactor)
	).normalized() * movementSpeed;
	
	# Move.
	move_and_slide();

func processPing(delta : float):
	# Safety first.
	if (!pingMaterial): 
		return;
	
	# Update ping values.
	pingCooldown -= delta;
	pingDistance += delta * pingSpeed;
	if (pingCooldown < 0): 
		# Reset ping origin.
		pingMaterial.set_shader_parameter("pingOrigin", global_position);
		# Reset cooldown.
		pingCooldown = maxPingCooldown;
		pingDistance = 0.0;
	
	# Set ping information.
	pingMaterial.set_shader_parameter("pingDistance", pingDistance);
