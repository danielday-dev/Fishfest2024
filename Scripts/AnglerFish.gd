extends Node3D

func _process(delta):
	var mainCamera : Camera3D = get_viewport().get_camera_3d();
	var lookPos : Vector3 = mainCamera.global_position;
	var selfPos : Vector3 = global_position;
	
	var forwards : Vector3 = Vector3(0, 0, 1);
	var right : Vector3 = Vector3(1, 0, 0);
	var up: Vector3 = Vector3(0, 1, 0);
	
	var dif = selfPos - lookPos;
	var difNorm = dif.normalized();
	const cos45 = cos(PI / 4.0);
	
	var directions = [
		-difNorm.dot(forwards),
		-difNorm.dot(right),
		-difNorm.dot(up)
	];
	var best = 0;
	for i in range(1, directions.size()):
		if (abs(directions[i]) > abs(directions[best])):
			best = i;
		
	$Sprites/Front.visible = best == 0 && directions[best] >= 0;
	$Sprites/Back.visible = best == 0 && directions[best] < 0;
	$Sprites/Right.visible = best == 1 && directions[best] >= 0;
	$Sprites/Left.visible = best == 1 && directions[best] < 0;
	$Sprites/Above.visible = best == 2 && directions[best] >= 0;
	$Sprites/Below.visible = best == 2 && directions[best] < 0;
	
