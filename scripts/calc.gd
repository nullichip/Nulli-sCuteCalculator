extends Control

var is_dragging: bool = false
var drag_offset: Vector2i = Vector2i()

var current_input: String = ""
var is_negative_pending: bool = false
var last_action: String = ""
@onready var container = $BaseCalc/HBoxContainer

@onready var cap = $AnimationPlayer

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
	_on_number_pressed("x")


func _on_bt_ndiv_pressed() -> void:
	_on_number_pressed("/")


func _on_bt_ndecimal_pressed() -> void:
	_on_number_pressed(".")


func _on_btnc_pressed() -> void:
	pass


func _on_bt_nsub_pressed() -> void:
	_on_number_pressed("-")


func _on_bt_nadd_pressed() -> void:
	_on_number_pressed("+")


func _on_bt_nequal_pressed() -> void:
	pass # Replace with function body.


func _on_btnonoff_pressed() -> void:
	cap.play("cap-on")
	await cap.animation_finished
	get_tree().quit()


func _on_c_ap_pressed() -> void:
	cap.play("cap-off")



#-----NUMBER SCRIPTS-----
func _on_number_pressed(digit: String) -> void:
	if current_input.length() >= 7:
		return
		
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
		pass
	last_action = "subtract"

func update_png_display() -> void:
	for child in container.get_children():
		child.queue_free()
	
	for char in current_input:
		var texture_path: String
		
		if char == "-":
			texture_path = "res://fonts/sub.png"
		if char == "+":
			texture_path = "res://fonts/add.png"
		if char == "x":
			texture_path = "res://fonts/mult.png"
		if char == "/":
			texture_path = "res://fonts/div.png"
		elif char == ".":
			texture_path = "res://fonts/decimal.png"
		else:
			texture_path = "res://fonts/" + char + ".png"
		
		var new_texture = TextureRect.new()
		new_texture.texture = load(texture_path)
		
		new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		new_texture.custom_minimum_size = Vector2(40,50)
		
		container.add_child(new_texture)



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
