extends VBoxContainer
class_name EditorGrid_GridControl

var grid_items = []
var grid: GridContainer
var hbox: HBoxContainer

signal cell_clicked
signal grid_size_changed

func _init(new_items):
	grid_items = new_items
	

func _ready() -> void:
	rect_min_size = Vector2(100, 30 * grid_items.size())
	_add_controls()
	_add_grid()
	update_items(grid_items)

func update_items(new_items):
	grid_items = new_items
	grid.columns = grid_items.size()

	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
		
	for x in grid_items.size():
		for y in grid_items[x].size():
			var btn = EditorGrid_GridButton.new(x, y, grid_items[x][y])
			btn.name = get_cell_name(x,y)
			btn.connect('on_pressed', self, '_on_button_pressed')
			grid.add_child(btn)

func get_cell_name(x,y):
	return "button-{x}-{y}".format({"x": str(x), "y": str(y)})

func _add_grid():
	grid = GridContainer.new()
	grid.columns = grid_items.size()
	grid.size_flags_vertical = SIZE_EXPAND
	add_child(grid)

func _add_controls():
	hbox = HBoxContainer.new()
	_add_control('+', "_on_add_button_pressed", hbox)
	_add_control('-', "_on_remove_button_pressed", hbox)
	_add_control('Reset', "_on_reset_button_pressed", hbox)
	hbox.size_flags_vertical = SIZE_EXPAND
	add_child(hbox)
	
func _add_control(text: String, on_pressed_signal: String, parent: Control):
	var btn = Button.new()
	btn.size_flags_horizontal = SIZE_EXPAND_FILL
	btn.text = text
	btn.connect('pressed', self, on_pressed_signal)
	parent.add_child(btn)
	

func _on_button_pressed(x, y, value):
	emit_signal('cell_clicked', x, y, value)

func _on_add_button_pressed():
	emit_signal('grid_size_changed', 1)

func _on_remove_button_pressed():
	emit_signal('grid_size_changed', -1)

func _on_reset_button_pressed():
	emit_signal('grid_size_changed', 0)
