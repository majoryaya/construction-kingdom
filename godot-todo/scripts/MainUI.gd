extends Control

@onready var manager := $TodoManager
@onready var input := $AddBar/Input
@onready var add_btn := $AddBar/AddButton
@onready var list_vbox := $Scroll/List
@onready var clear_btn := $ClearAll

func _ready() -> void:
	add_btn.connect("pressed", Callable(self, "_on_add_pressed"))
	input.connect("text_entered", Callable(self, "_on_text_entered"))
	clear_btn.connect("pressed", Callable(self, "_on_clear_pressed"))
	refresh_list()

func _on_add_pressed() -> void:
	_add_from_input()

func _on_text_entered(new_text: String) -> void:
	_add_from_input()

func _add_from_input() -> void:
	var t = input.text.strip_edges()
	if t == "":
		return
	manager.add_todo(t)
	input.text = ""
	refresh_list()

func _on_clear_pressed() -> void:
	manager.clear_all()
	refresh_list()

func refresh_list() -> void:
	# remove previous children
	for child in list_vbox.get_children():
		child.queue_free()
	# recreate rows
	for todo in manager.todos:
		_create_row(todo)

func _create_row(todo: Dictionary) -> void:
	var id = int(todo.get("id"))
	var text = str(todo.get("text"))
	var done = bool(todo.get("done"))

	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(0, 40)

	var cb := CheckBox.new()
	cb.pressed = done
	cb.connect("pressed", Callable(self, "_on_toggle_pressed"), [id])
	row.add_child(cb)

	var label := LineEdit.new()
	label.text = text
	label.select_all()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.connect("text_changed", Callable(self, "_on_text_changed"), [id])
	row.add_child(label)

	var del := Button.new()
	del.text = "Supprimer"
	del.connect("pressed", Callable(self, "_on_delete_pressed"), [id])
	row.add_child(del)

	if done:
		label.editable = false

	list_vbox.add_child(row)

func _on_toggle_pressed(id: int) -> void:
	manager.toggle_done(id)
	refresh_list()

func _on_delete_pressed(id: int) -> void:
	manager.remove_todo(id)
	refresh_list()

func _on_text_changed(new_text: String, id: int) -> void:
	manager.update_todo_text(id, new_text)
