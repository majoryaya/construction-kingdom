extends Control

@onready var manager := $TodoManager
@onready var input := $AddBar/Input
@onready var desc_input := $AddBar/DescInput
@onready var due_input := $AddBar/DueInput
@onready var add_btn := $AddBar/AddButton
@onready var filter_all := $FilterBar/FilterAll
@onready var filter_active := $FilterBar/FilterActive
@onready var filter_done := $FilterBar/FilterDone
@onready var list_vbox := $Scroll/List
@onready var clear_btn := $ClearAll

enum Filter { ALL, ACTIVE, DONE }
var current_filter: int = Filter.ALL

func _ready() -> void:
	add_btn.connect("pressed", Callable(self, "_on_add_pressed"))
	input.connect("text_entered", Callable(self, "_on_text_entered"))
	desc_input.connect("text_entered", Callable(self, "_on_text_entered"))
	due_input.connect("text_entered", Callable(self, "_on_text_entered"))
	clear_btn.connect("pressed", Callable(self, "_on_clear_pressed"))
	filter_all.connect("pressed", Callable(self, "_on_filter_pressed"), [Filter.ALL])
	filter_active.connect("pressed", Callable(self, "_on_filter_pressed"), [Filter.ACTIVE])
	filter_done.connect("pressed", Callable(self, "_on_filter_pressed"), [Filter.DONE])
	refresh_list()

func _on_add_pressed() -> void:
	_add_from_input()

func _on_text_entered(new_text: String) -> void:
	# pressing Enter in any input will try to add
	_add_from_input()

func _add_from_input() -> void:
	var t = input.text.strip_edges()
	var d = desc_input.text.strip_edges()
	var due = due_input.text.strip_edges()
	if t == "":
		return
	manager.add_todo(t, d, due)
	input.text = ""
	desc_input.text = ""
	due_input.text = ""
	refresh_list()

func _on_clear_pressed() -> void:
	manager.clear_all()
	refresh_list()

func _on_filter_pressed(filter_val: int) -> void:
	current_filter = filter_val
	refresh_list()

func refresh_list() -> void:
	# remove previous children
	for child in list_vbox.get_children():
		child.queue_free()
	# recreate rows filtered
	for todo in manager.todos:
		var done = bool(todo.get("done"))
		if current_filter == Filter.ACTIVE and done:
			continue
		if current_filter == Filter.DONE and not done:
			continue
		_create_row(todo)

func _create_row(todo: Dictionary) -> void:
	var id = int(todo.get("id"))
	var text = str(todo.get("text"))
	var desc = str(todo.get("description"))
	var due = str(todo.get("due"))
	var done = bool(todo.get("done"))

	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(0, 48)

	var cb := CheckBox.new()
	cb.pressed = done
	cb.connect("pressed", Callable(self, "_on_toggle_pressed"), [id])
	row.add_child(cb)

	var title := LineEdit.new()
	title.text = text
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.connect("text_changed", Callable(self, "_on_text_changed"), [id])
	row.add_child(title)

	var desc_field := LineEdit.new()
	desc_field.text = desc
	desc_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc_field.placeholder_text = "Description"
	desc_field.connect("text_changed", Callable(self, "_on_desc_changed"), [id])
	row.add_child(desc_field)

	var due_field := LineEdit.new()
	due_field.text = due
	due_field.placeholder_text = "Échéance"
	due_field.size_flags_horizontal = Control.SIZE_FILL
	due_field.custom_minimum_size = Vector2(120, 0)
	due_field.connect("text_changed", Callable(self, "_on_due_changed"), [id])
	row.add_child(due_field)

	var del := Button.new()
	del.text = "Supprimer"
	del.connect("pressed", Callable(self, "_on_delete_pressed"), [id])
	row.add_child(del)

	if done:
		title.editable = false
		desc_field.editable = false
		due_field.editable = false

	list_vbox.add_child(row)

func _on_toggle_pressed(id: int) -> void:
	manager.toggle_done(id)
	refresh_list()

func _on_delete_pressed(id: int) -> void:
	manager.remove_todo(id)
	refresh_list()

func _on_text_changed(new_text: String, id: int) -> void:
	manager.update_todo_text(id, new_text)

func _on_desc_changed(new_text: String, id: int) -> void:
	manager.update_todo_description(id, new_text)

func _on_due_changed(new_text: String, id: int) -> void:
	manager.update_todo_due(id, new_text)
