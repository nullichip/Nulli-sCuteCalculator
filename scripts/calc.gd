extends Control

var is_dragging: bool = false
var drag_offset: Vector2i = Vector2i()

var current_input: String = ""
var is_negative_pending: bool = false
var last_action: String = ""

@onready var container = $BaseCalc/ScrollContainer/HBoxContainer
@onready var scroll_container = $BaseCalc/ScrollContainer
@onready var cap = $AnimationPlayer

@onready var click_sound = $ClickSound
@onready var power_sound = $PowerOnSound
@onready var power_off_sound = $PowerOffSound

func _ready() -> void:
	power_sound.play()

func _on_btn_1_pressed() -> void:
	_on_number_pressed("1")

func _on_btn_2_pressed() -> void:
	_on_number_pressed("2")


func _on_btn_3_pressed() -> void:
	_on_number_pressed("3")


func _on_btn_4_pressed() -> void:
	_on_number_pressed("4")


func _on_btn_5_pressed() -> void:
	_on_number_pressed("5")


func _on_btn_6_pressed() -> void:
	_on_number_pressed("6")


func _on_btn_7_pressed() -> void:
	_on_number_pressed("7")


func _on_btn_8_pressed() -> void:
	_on_number_pressed("8")


func _on_btn_9_pressed() -> void:
	_on_number_pressed("9")


func _on_btn_0_pressed() -> void:
	_on_number_pressed("0")


func _on_bt_nmult_pressed() -> void:
	click_sound.play()
	_on_number_pressed("x")
	last_action = "multiply"


func _on_bt_ndiv_pressed() -> void:
	click_sound.play()
	_on_number_pressed("/")
	last_action = "divide"


func _on_bt_ndecimal_pressed() -> void:
	click_sound.play()
	_on_number_pressed(".")
	last_action = "decimal"


func _on_btnc_pressed() -> void:
	click_sound.play()
	current_input = ""
	is_negative_pending = false
	last_action = "clear"
	
	update_png_display()


func _on_bt_nsub_pressed() -> void:
	click_sound.play()
	_on_number_pressed("-")
	last_action = "subtract"


func _on_bt_nadd_pressed() -> void:
	click_sound.play()
	_on_number_pressed("+")
	last_action = "add"


func _on_bt_nequal_pressed() -> void:
	click_sound.play()
	if current_input == "":
		return
	
	var math_parser = Expression.new()
	
	var safe_equation = current_input.replace("x", "*")
	
	safe_equation = safe_equation.replace("/", "* 1.0 /")
	
	safe_equation = safe_equation.replace("--", "- -")
	safe_equation = safe_equation.replace("+-", "+ -")
	safe_equation = safe_equation.replace("*-", "* -")
	safe_equation = safe_equation.replace("/-", "/ -")
	
	var parse_error = math_parser.parse(safe_equation)
	if parse_error != OK:
		print("Invalid equation")
		current_input = "Error"
		update_png_display()
		return
	
	var result = math_parser.execute()
	
	if math_parser.has_execute_failed():
		print("Execution failed")
		current_input = "Error"
	
	else:
		var rounded_result = snapped(float(result), 0.00001)
		current_input = str(rounded_result)
	
	last_action = "equal"
	update_png_display()

func _on_btnonoff_pressed() -> void:
	power_off_sound.play()
	cap.play("cap-on")
	await cap.animation_finished
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_c_ap_pressed() -> void:
	click_sound.play()
	cap.play("cap-off")



#-----NUMBER SCRIPTS-----
func _on_number_pressed(digit: String) -> void:
	click_sound.play()
	if last_action == "equal" and digit in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
		current_input = ""
		is_negative_pending = false
	
	if is_negative_pending and current_input == "":
		current_input = "-" + digit
		is_negative_pending = false
	else:
		current_input += digit
	last_action = "number"
	update_png_display()

func _on_subtract_pressed() -> void:
	if last_action == "subract":
		is_negative_pending = true
	else:
		_on_number_pressed("-")
	last_action = "subtract"

func update_png_display() -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	for char in current_input:
		var texture_path: String
		
		if char == "-":
			texture_path = "res://fonts/minus.png"
		elif char == "+":
			texture_path = "res://fonts/add.png"
		elif char == "x":
			texture_path = "res://fonts/mult.png"
		elif char == "/":
			texture_path = "res://fonts/div.png"
		elif char == ".":
			texture_path = "res://fonts/decimal.png"
		elif char == "E":
			texture_path = "res://fonts/Error.png"
		elif char == "r":
			texture_path = "res://fonts/Error.png"
		elif char == "o":
			texture_path = "res://fonts/Error.png"
		else:
			texture_path = "res://fonts/" + char + ".png"
		
		var new_texture = TextureRect.new()
		new_texture.texture = load(texture_path)
		
		new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		new_texture.custom_minimum_size = Vector2(50,70)
		
		container.add_child(new_texture)
		
	await get_tree().process_frame
	scroll_container.scroll_horizontal = scroll_container.get_h_scroll_bar().max_value



#-----WINDOW SCRIPTS-----
func _on_base_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_offset = Vector2i(get_local_mouse_position())
				print("Dragging...")
			else:
				is_dragging = false
				print("Dragging has stopped")
	if event is InputEventMouseMotion and is_dragging:
		#event.relative is a Vector2 that tells us how far the mouse has moved
		#convert to Vector2i because the window positions use whole numbers.
		get_window().position = DisplayServer.mouse_get_position() - drag_offset
