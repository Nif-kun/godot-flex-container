tool
extends Container

#TODO:
#>Add a fix/implementation for resizing with rect_min_size of children.

#Size (of the grid)
var _columns := 1 setget set_columns, get_columns
var _rows := 1 setget set_rows, get_rows

#Blocks (the placeholder for the span and row of the container's children)
var _blocks := PoolVector2Array([Vector2(1,1)]) setget set_blocks, get_blocks

#Content Margin
var _top_margin := 0 setget set_top_margin, get_top_margin
var _bottom_margin := 0 setget set_bottom_margin, get_bottom_margin
var _right_margin := 0 setget set_right_margin, get_right_margin
var _left_margin := 0 setget set_left_margin, get_left_margin

#Separation (or space between Blocks)
var _horizontal := 4 setget set_horizontal, get_horizontal
var _vertical := 4  setget set_vertical, get_vertical

#Flags
var _compact := false setget set_compact, get_compact #Fill in empty spaces with the next block that fits
var _limit_visible := false setget set_limit_visible, get_limit_visible #Hide children outside of Blocks' array size.
var _disable_min_size := true setget set_disable_min_size, get_disable_min_size  
#^Proper resize with minimum has not been implemented. Turning _disable_min_size off can cause unexpected crashes or lag.
#^It is only applicable to use if all children has proper rect_min_size values.
var _child_count := 0 #Refer to _notification method

#Creates an export for the FlexContainer's inspector.
func _get_property_list() -> Array:
	return [
		{
			"name": "FlexContainer",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_CATEGORY,
		},
		{
			"name": "_columns",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		},
		{
			"name": "_rows",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_blocks",
			"type": TYPE_VECTOR2_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_compact",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_limit_visible",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_disable_min_size",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "Content Margin",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
		},
		{
			"name": "_top_margin",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_bottom_margin",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_left_margin",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_right_margin",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "Separation",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
		},
		{
			"name": "_horizontal",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
		{
			"name": "_vertical",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
		},
	]

#Gives the option to revert a property to default state.
func property_can_revert(property):
	match property:
		"_columns":
			return true
		"_rows":
			return true
		"_blocks":
			return true
		"_top_margin":
			return true
		"_bottom_margin":
			return true
		"_left_margin":
			return true
		"_right_margin":
			return true
		"_horizontal":
			return true
		"_vertical":
			return true
		"_compact":
			return true
		"_limit_visible":
			return true
		"_disable_min_size":
			return true
		_:
			return false

#Sets the default value on revert.
func property_get_revert(property):
	match property:
		"_columns":
			return 1
		"_rows":
			return 1
		"_blocks":
			return PoolVector2Array([Vector2(1,1)])
		"_top_margin":
			return 0
		"_bottom_margin":
			return 0
		"_left_margin":
			return 0
		"_right_margin":
			return 0
		"_horizontal":
			return 4
		"_vertical":
			return 4
		"_compact":
			return false
		"_limit_visible":
			return false
		"_disable_min_size":
			return true


#Setget _columns
func set_columns(value):
	if value > 0:
		_columns = value
		_sort_display()
		return
	_columns = 1
	_sort_display()

func get_columns() -> int:
	return _columns


#Setget _rows
func set_rows(value):
	if value > 0:
		_rows = value
		_sort_display()
		return
	_rows = 1
	_sort_display()

func get_rows() -> int:
	return _rows


#Setget Blocks
#Note:
#For-loop changes doesn't affect the array in any way. Thus a count solution.
#Vector values in array also does not visually update instantly, sadly.
func set_blocks(value):
	if value.size() > 0:
		var new_blocks = value
		var count = new_blocks.size()
		for vector in new_blocks:
			if new_blocks[count-1].x < 1:
				new_blocks[count-1].x = 1
			if new_blocks[count-1].y < 1:
				new_blocks[count-1].y = 1
			count-=1
		_blocks = new_blocks
		_sort_display()
		return
	_blocks = PoolVector2Array([Vector2(1,1)])
	_sort_display()

func get_blocks() -> PoolVector2Array:
	return _blocks


#Setget Top Margin
func set_top_margin(value):
	if value > 0:
		_top_margin = value
		_sort_display()
		return
	_top_margin = 0
	_sort_display()

func get_top_margin() -> int:
	return _top_margin


#Setget Bottom Margin
func set_bottom_margin(value):
	if value > 0:
		_bottom_margin = value
		_sort_display()
		return
	_bottom_margin = 0
	_sort_display()

func get_bottom_margin() -> int:
	return _bottom_margin


#Setget Left Margin
func set_left_margin(value):
	if value > 0:
		_left_margin = value
		_sort_display()
		return
	_left_margin = 0
	_sort_display()

func get_left_margin() -> int:
	return _left_margin


#Setget Right Margin
func set_right_margin(value):
	if value > 0:
		_right_margin = value
		_sort_display()
		return
	_right_margin = 0
	_sort_display()

func get_right_margin() -> int:
	return _right_margin


#Setget Horizontal
func set_horizontal(value):
	if value > 0:
		_horizontal = value
		_sort_display()
		return
	_horizontal = 4
	_sort_display()

func get_horizontal() -> int:
	return _horizontal


#Setget Vertical
func set_vertical(value):
	if value > 0:
		_vertical = value
		_sort_display()
		return
	_vertical = 4
	_sort_display()

func get_vertical() -> int:
	return _vertical


#Setget Compact
func set_compact(value):
	_compact = value
	_sort_display()

func get_compact() -> bool:
	return _compact


#Setget Limit Visible
func set_limit_visible(value):
	_limit_visible = value
	if _limit_visible:
		_hide_unused(get_children())
	else:
		_show_unused(get_children())

func get_limit_visible() -> bool:
	return _limit_visible


#Setget Disabled Min Size
func set_disable_min_size(value):
	_disable_min_size = value
	if _disable_min_size:
		_remove_min_rect(get_children())

func get_disable_min_size() -> bool:
	return _disable_min_size


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("item_rect_changed", self, "_rect_resized")
	connect("visibility_changed", self, "_visibility_changed")


func _rect_resized():
	_sort_display()


func _visibility_changed():
	_sort_display()


func _notification(what):
	if Engine.editor_hint:
		#The condition below allows checking for any node enter/exit and reposition.
		if _child_count != get_child_count() || what == NOTIFICATION_DRAW:
			_child_count = get_child_count()
			_sort_display()


func _sort_display():
	var content_size := Vector2((rect_size.x - (_left_margin + _right_margin)), (rect_size.y - (_top_margin + _bottom_margin)))
	if _blocks.size() > 1: 
		if _columns > 1:
			content_size.x -= (_columns-1) * _horizontal
		if _rows > 1:
			content_size.y -= (_rows-1) * _vertical
	var children := get_children()
	for index in range(0, get_child_count(), 1):
		if index+1 <= _blocks.size() and index+1 <= (_columns*_rows):
			if not children[index].visible and not children[index] is Popup:
				children[index].show()
			_resize(index, children, content_size)
			if _compact:
				_reposition_compact(index, children, content_size)
				continue #Goes to next child
			_reposition(index, children, content_size)
	if _disable_min_size:
		_remove_min_rect(children)
	if _limit_visible:
		_hide_unused(children)
		return #Exits
	_show_unused(children)


func _hide_unused(children):
	for i in range(get_child_count()-1, -1, -1):
		if children[i].visible == true:
			if i+1 > _blocks.size() or i+1 > (_columns*_rows):
				children[i].hide()
			elif children[i].get_rect().end.y >= rect_size.y: 
				children[i].hide()


func _show_unused(children):
	for i in range(get_child_count()-1, -1, -1):
		if children[i].visible == false:
			if i+1 > _blocks.size() or i+1 > (_columns*_rows): 
				children[i].show()
			elif children[i].get_rect().end.y > rect_size.y:
				children[i].show()


func _remove_min_rect(children):
	for i in range(0, get_child_count(), 1):
		if children[i].rect_min_size > Vector2.ZERO:
			children[i].rect_min_size = Vector2.ZERO


#Note:
#>ceil lessens the jitter but not fully, haven't found a solution.
func _resize(index, children, content_size):
	var block = _blocks[index]
	if block.x > _columns:
		block.x = _columns
	if block.y > _rows:
		block.y = _rows
	var width = (round(content_size.x / _columns) * block.x) + (_horizontal * (block.x-1))
	var height = (round(content_size.y / _rows) * block.y) + (_vertical * (block.y-1))
	var size := Vector2(width, height)
	children[index].rect_size = size


#Note:
#>ceil lessens the jitter but not fully, haven't found a solution.
func _reposition(index, children, content_size):
	if index > 0:
		children[index].rect_position.x = children[index-1].get_rect().end.x + _horizontal
		children[index].rect_position.y = children[index-1].rect_position.y
		while true:
			var flag = 0
			
			#IF child is outside of (self) parent's rect_size.
			if children[index].get_rect().end.x > rect_size.x+(children[index].get_rect().size.x/2)-_right_margin:
				children[index].rect_position.y += (round(content_size.y / _rows) + _vertical)
				children[index].rect_position.x = _left_margin
				flag+=1
			
			#IF child is intersecting with another child loaded before it.
			var intersecting_rect : Rect2 = _get_intersecting_rect(index, children, true)
			if !intersecting_rect.has_no_area(): #Double negative
				children[index].rect_position.x = intersecting_rect.end.x + _horizontal
				flag+=1
			
			if flag == 0:
				break
	else: #IF initial
		children[index].rect_position = Vector2(_left_margin, _top_margin)


func _get_intersecting_rect(index, children, reverse:bool=false) -> Rect2:
	var start := 0
	var end = index
	var step := 1
	if reverse:
		start = index
		end = 0
		step = -1
	for i in range(start, end, step):
		var x = i
		if reverse:
			x-=1
		if children[index].get_rect().intersects(children[x].get_rect()):
			return children[i-1].get_rect()
	return Rect2() #Empty, because for some reason you can't use null :harold:


func _reposition_compact(index, children, content_size):
	var block_rect_size := Vector2(round(content_size.x / _columns), round(content_size.y / _rows))
	children[index].rect_position = Vector2(_left_margin, _top_margin)
	if index > 0:
		for i in range(0, (_columns*_rows), 1):
			var flag = 0
			
			if children[index].get_rect().end.x > rect_size.x+(children[index].get_rect().size.x/2)-_right_margin:
				flag+=1
			if !_get_intersecting_rect(index, children).has_no_area():
				flag+=1
			
			if flag == 0:
				children[index].rect_position
				break
			
			children[index].rect_position.x += block_rect_size.x + _horizontal
			if (i+1)%_columns == 0:
				children[index].rect_position.y += block_rect_size.y + _vertical
				children[index].rect_position.x = _left_margin
