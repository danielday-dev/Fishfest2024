extends Node3D

func _ready():
	GlobalState.keysPlaceRemaining += 1;

func playPickupNoise():
	$PickupNoise.play()
