extends Node3D

@export var speed :float;
@onready var initial_position : Vector3 = $Sprite.position;

var GO :bool = false;
var time : float = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !GO:
		return
	
	time += delta*speed;
	
	$Sprite.position = lerp(initial_position, Vector3.ZERO, sin(time))
	if time > PI:
		queue_free()
		
func tryJumpscare():
	GO = true;


func _on_activate_zone_body_entered(body):
	tryJumpscare();
