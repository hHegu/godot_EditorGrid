extends EditorProperty
class_name EditorGridProperty

var grid: EditorGrid_GridControl
var current_value = []

var updating := false

func _init(items):
	grid = EditorGrid_GridControl.new(items)

	grid.connect('cell_clicked', self, '_on_cell_clicked')
	grid.connect('grid_size_changed', self, '_on_grid_size_changed')
	current_value = items
	add_child(grid)

func _on_cell_clicked(x: int, y: int, value: bool):
	if updating:
		return
	updating = true
	
	current_value = get_edited_object().grid
	current_value[x][y] = value
	emit_changed(get_edited_property(), current_value)
	grid.update_items(current_value)
	
	updating = false

func _on_grid_size_changed(amount):
	if updating:
		return
	updating = true

	current_value = get_edited_object().grid
	var columns = current_value.size()
	print(amount)
	if amount > 0:
		for row in current_value:
			for i in amount:
				(row as Array).append(false)
		current_value.append(get_bool_array(columns + amount))
	
	if amount < 0:
		for row in current_value:
			row.pop_back()
		current_value.pop_back()
		
	if amount == 0:
		current_value = [get_bool_array(3), get_bool_array(3), get_bool_array(3)]

		
	emit_changed(get_edited_property(), current_value)
	grid.update_items(current_value)
	updating = false

func update_property():
	# Read the current value from the property.
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_value):
		return

	# Update the control with the new value.
	updating = true
	current_value = new_value
	grid.update_items(current_value)
	updating = false


func get_bool_array(size: int):
	var arr = []
	for i in size:
		arr.append(false)
	return arr
