extends CharacterBody3D

@export var movementSpeed : float = 2.0;
@export var nonForwardMovementFactor : float = 0.4;

@export var mainCamera : Camera3D;
@export var pingPrefab : PackedScene;
@export var pingCount : int = 30;
@export_range(PI / 9.0, PI) var pingRadius : float = PI / 2.0;	

func _process(_delta):
	if (Input.is_action_just_pressed("Player_Ability_Ping")):
		ping_environment();

func _physics_process(delta):
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
	
	# Update velocity.
	velocity = (
		(forward * playerMovement.z) + 
		(up * playerMovement.y * nonForwardMovementFactor) + 
		(right * playerMovement.x * nonForwardMovementFactor)
	).normalized() * movementSpeed;
	
	# Move.
	move_and_slide();

func ping_environment():
	# Safety first.
	if (!mainCamera || !pingPrefab): 
		return;
	
	# Get collision space.
	var space = get_world_3d().direct_space_state;
	
	# Ping.
	var pingMultiplier : float = pingRadius / pingCount as float;
	for i in range(-pingCount, pingCount):
		for j in range(-pingCount / 2, pingCount / 2):		
			# Get angle.
			var ax = (i as float) * pingMultiplier;
			var ay = (j as float) * pingMultiplier;
			var forward : Vector3 = Vector3(
				cos(rotation.x + ay) * -sin(rotation.y + ax),
				sin(rotation.x + ay),
				cos(rotation.x + ay) * -cos(rotation.y + ax)
			);
			
			# Ping.
			var query = PhysicsRayQueryParameters3D.create(
				mainCamera.global_position, 
				mainCamera.global_position + (forward * 100.0)
			);
			var collision = space.intersect_ray(query);
		
			if (collision):
				var ping = pingPrefab.instantiate();
				ping.position = collision.position;
				get_tree().root.add_child(ping);
