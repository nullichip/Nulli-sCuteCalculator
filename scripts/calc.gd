extends Control

var is_dragging: bool = false
var drag_offset: Vector2i = Vector2i()
@onready var cap = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_1_pressed() -> void:
	pass # Replace with function body.


func _on_btn_2_pressed() -> void:
	pass # Replace with function body.


func _on_btn_3_pressed() -> void:
	pass # Replace with function body.


func _on_btn_4_pressed() -> void:
	pass # Replace with function body.


func _on_btn_5_pressed() -> void:
	pass # Replace with function body.


func _on_btn_6_pressed() -> void:
	pass # Replace with function body.


func _on_btn_7_pressed() -> void:
	pass # Replace with function body.


func _on_btn_8_pressed() -> void:
	pass # Replace with function body.


func _on_btn_9_pressed() -> void:
	pass # Replace with function body.


func _on_btn_0_pressed() -> void:
	pass # Replace with function body.


func _on_btn_pressed() -> void:
	pass # Replace with function body.


func _on_bt_nmult_pressed() -> void:
	pass # Replace with function body.


func _on_bt_ndiv_pressed() -> void:
	pass # Replace with function body.


func _on_bt_npara_pressed() -> void:
	pass # Replace with function body.


func _on_bt_ndecimal_pressed() -> void:
	pass # Replace with function body.


func _on_btnc_pressed() -> void:
	pass # Replace with function body.


func _on_bt_nsub_pressed() -> void:
	pass # Replace with function body.


func _on_bt_nadd_pressed() -> void:
	pass # Replace with function body.


func _on_btnonoff_pressed() -> void:
	cap.play("cap-on")
	await cap.animation_finished
	get_tree().quit()

func _on_bt_nequal_pressed() -> void:
	pass # Replace with function body.


func _on_c_ap_pressed() -> void:
	cap.play("cap-off")


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


func _on_cap_calc_gui_input(event: InputEvent) -> void:
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
