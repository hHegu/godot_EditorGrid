extends CheckBox
class_name EditorGrid_GridButton

var x: int
var y: int
var value: bool

signal on_pressed

func _init(x: int, y: int, value: bool):
	self.x = x
	self.y = y
	self.value = value
	pressed = value

func _ready() -> void:
	connect('pressed', self, "_on_press")
	
func _on_press():
	emit_signal('on_pressed', x, y, pressed)
