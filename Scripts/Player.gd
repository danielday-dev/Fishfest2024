extends Node3D

@export var movementSpeed : float = 2.0;
@export var nonForwardMovementFactor : float = 0.4;

func _process(delta):
	# Get input.	
	var cameraMovement : Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_down", "ui_up")
	);
	var playerMovement : Vector3 = Vector3(
		Input.get_axis("Player_Movement_Left", "Player_Movement_Right"),
		Input.get_axis("Player_Movement_Down", "Player_Movement_Up"),
		Input.get_axis("Player_Movement_Backward", "Player_Movement_Forward")
	);
	
	# Handle rotation.
	rotation.y += -cameraMovement.x * delta;
	rotation.x += cameraMovement.y * delta;

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
	
	# TODO: CharacterBody3D
	# Update position.
	position += (
		(forward * playerMovement.z) + 
		(up * playerMovement.y * nonForwardMovementFactor) + 
		(right * playerMovement.x * nonForwardMovementFactor)
	).normalized() * movementSpeed * delta;
		
