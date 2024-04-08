extends CanvasLayer

func _ready():
	visible = Input.mouse_mode == Input.MOUSE_MODE_VISIBLE;				

func _process(delta):
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if (Input.is_action_just_pressed("ui_escape")):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			visible = true;			
	elif (Input.is_action_just_pressed("ui_enter")):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;		
		visible = false;

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
