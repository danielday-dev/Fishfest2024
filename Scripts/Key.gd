extends Node3D

@export var rotationSpeed : float = 1.0;
@export var bobSpeed : float = 1.0;
@export var bobHeight : float = 0.5;

@onready var basePosition : Vector3 = position;
var floatTime : float = 0.0;
func _process(delta):
	rotation.y += delta * rotationSpeed;
	floatTime += delta * bobSpeed;
	position = basePosition + Vector3(0, sin(floatTime) * bobHeight, 0);

var pickedUp : bool = false;
signal onPickedUp
func onPickup(body):
	# Safety first.
	if (pickedUp): 
		return
	pickedUp = true;
	
	# Increment key count.
	GlobalState.keysPickedUp += 1;
	onPickedUp.emit()
	queue_free();

signal onPlaced;
@export_file("*.tscn") var winScene;
func onPlace(body):
	# Decrement key count.
	if (GlobalState.keysPickedUp <= 0 || !winScene || visible):
		return;
	GlobalState.keysPickedUp -= 1;
	
	# Show key.
	visible = true;
	$Item_Key/KeyGlow.queue_free();
	onPlaced.emit();
	
	# Check 
	GlobalState.keysPlaceRemaining -= 1;
	if (GlobalState.keysPlaceRemaining <= 0):
		call_deferred("enterWinScene");

func enterWinScene():
	get_tree().change_scene_to_file(winScene);
