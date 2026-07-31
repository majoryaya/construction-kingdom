extends Node

# Simple Todo manager with JSON persistence in user://todos.json
# Each todo is a Dictionary: {"id": int, "text": String, "done": bool}

var todos: Array = []
var next_id: int = 1
const SAVE_PATH := "user://todos.json"

func _ready() -> void:
	load_todos()

func add_todo(text: String) -> void:
	if text.strip_edges() == "":
		return
	var item = {"id": next_id, "text": text, "done": false}
	todos.append(item)
	next_id += 1
	save_todos()

func toggle_done(id: int) -> void:
	for t in todos:
		if int(t.get("id")) == id:
			t["done"] = not bool(t.get("done"))
			save_todos()
			return

func remove_todo(id: int) -> void:
	todos = todos.filter(func(x): return int(x.get("id")) != id)
	save_todos()

func update_todo_text(id: int, new_text: String) -> void:
	for t in todos:
		if int(t.get("id")) == id:
			t["text"] = new_text
			save_todos()
			return

func clear_all() -> void:
	todos.clear()
	save_todos()

func save_todos() -> void:
	var json_text = JSON.stringify(todos)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_text)
		file.close()

func load_todos() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		todos = []
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var txt = file.get_as_text()
		file.close()
		var res = JSON.parse_string(txt)
		if res.error == OK:
			todos = res.result
			# recalc next_id
			next_id = 1
			for t in todos:
				var id = int(t.get("id"))
				if id >= next_id:
					next_id = id + 1
		else:
			todos = []
