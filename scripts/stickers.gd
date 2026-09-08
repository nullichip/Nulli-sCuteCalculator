extends TextureRect

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var save_path: String = "user://stickers_v5.cfg" 

func _ready() -> void:
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		if config.has_section_key("Positions", name):
			position = config.get_value("Positions", name)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_dragging = true
		drag_offset = get_global_mouse_position() - global_position

func _input(event: InputEvent) -> void:
	if not is_dragging:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		is_dragging = false
		save_position()
		
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position() - drag_offset
		
		var parent_size = get_parent().size
		
		position.x = clamp(position.x, 0, parent_size.x - size.x)
		position.y = clamp(position.y, 0, parent_size.y - size.y)

func save_position() -> void:
	var config = ConfigFile.new()
	config.load(save_path) 
	config.set_value("Positions", name, position)
	config.save(save_path)
