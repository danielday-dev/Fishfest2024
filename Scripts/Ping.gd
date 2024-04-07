extends MeshInstance3D

@export var maxLifeTime : float = 5.0;
var activeLifeTime : float;

func _ready():
	activeLifeTime = randf_range(maxLifeTime * 0.5, maxLifeTime);
	
func _process(delta):
	# Update life.
	activeLifeTime -= delta;
	
	# Update scale.
	scale = Vector3.ONE * activeLifeTime / maxLifeTime;
	
	# Ping duration ended.
	if (activeLifeTime <= 0):
		queue_free();
