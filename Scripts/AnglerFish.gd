extends Node3D

@export var movementSpeed : float = 1.0;
@export var killDistance : float = 0.1;
@export_file("*.tscn") var loseScene;

var target : Node3D;
func _process(delta):
	if (!target || !loseScene):
		return;
	
	global_position = global_position.move_toward(target.global_position, delta * movementSpeed);
	if (global_position.distance_to(target.global_position) < killDistance):
		call_deferred("enterLoseScene");

func _onKillzoneEntered(body):
	target = body;

func enterLoseScene():
	get_tree().change_scene_to_file(loseScene);
