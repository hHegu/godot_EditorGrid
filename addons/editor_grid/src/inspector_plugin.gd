extends EditorInspectorPlugin

func can_handle(object: Object) -> bool:
	return object is EditorGrid

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path == 'grid':
		add_property_editor(path, EditorGridProperty.new(object.grid))
		return true
	return false
