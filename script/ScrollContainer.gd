extends ScrollContainer


export (Vector2) var delta_for_swipe := Vector2(1, 1) 

var look_for_swipe := false
var swiping := false
var swipe_start : Vector2
var swipe_mouse_start : Vector2
var swipe_mouse_times := []
var swipe_mouse_positions := []
var tween : Tween

var OSSize = OS.window_size

func obtenerNewViewPort()->Rect2:
	var rect2:Rect2 = Rect2()
	var resolucionH = rect_size.x/get_viewport_rect().size.y
	var resolucionV = rect_size.y/get_viewport_rect().size.x
	var newSizeX =  resolucionH * OSSize.y
	var newSizeY =  resolucionV * newSizeX
	
#	print("RH ",str(resolucionH))
#	print("RV ",str(resolucionV))
#	print("Tm ",str(OSSize))
#	print("Sx ",str(newSizeX))
#	print("SY ",str(newSizeY))
#	print("tamaño => X ",str(newSizeX)," Y ",str(newSizeY))
##	print("resolucion => X ",str(rect_position.x)," Y ",str(resolucion))
	rect2.position = Vector2(0,(OSSize.y - newSizeY)/2)
	rect2.size = Vector2(newSizeX ,newSizeY)
	print("rect -> ",str(rect2))
	return rect2
	
func _input(ev) -> void:
	if !is_visible_in_tree():
		return
		
	if ev is InputEventScreenDrag and swiping:
		#cmd.text = cmd.text+"\n"+str(ev)
		accept_event()
		return
		
	if ev is InputEventMouseButton:
#		if ev.pressed: ->en Caso que no funcione la linea de abajo
		if ev.pressed and obtenerNewViewPort().has_point(ev.global_position):
			look_for_swipe = true
			swipe_mouse_start = ev.global_position
			OSSize = OS.window_size
			
		elif swiping:
			swipe_mouse_times.append(OS.get_ticks_msec())
			swipe_mouse_positions.append(ev.global_position)
			var source := Vector2(get_h_scroll(), get_v_scroll())
			var idx := swipe_mouse_times.size() - 1
			var now := OS.get_ticks_msec()
			var cutoff := now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff: 
					idx = i
				else: break
			var flick_start : Vector2 = swipe_mouse_positions[idx]
			var flick_dur := min(0.3, (ev.global_position - flick_start).length() / 1000)
			if flick_dur > 0.0:
				tween = Tween.new()
				add_child(tween)
				var delta : Vector2 = ev.global_position - flick_start
				var target := source - delta * flick_dur * 15.0
				tween.interpolate_method(self, 'set_h_scroll', source.x, target.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_method(self, 'set_v_scroll', source.y, target.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_callback(tween, flick_dur, 'queue_free')
				tween.start()
			swiping = false
			swipe_mouse_times = []
			swipe_mouse_positions = []
#			print("start2");
			
		else:
			look_for_swipe = false
			
	if ev is InputEventMouseMotion:
			
		if look_for_swipe:
			var delta = ev.global_position - swipe_mouse_start
			if abs(delta.x) > delta_for_swipe.x or abs(delta.y) > delta_for_swipe.y:
				swiping = true
				look_for_swipe = false
				swipe_start = Vector2(get_h_scroll(), get_v_scroll())
				swipe_mouse_start = ev.global_position
				swipe_mouse_times = [OS.get_ticks_msec()]
				swipe_mouse_positions = [swipe_mouse_start]
				if is_instance_valid(tween) and tween is Tween:
					tween.stop_all()
		
		if swiping:
			var delta : Vector2 = ev.global_position - swipe_mouse_start
			set_h_scroll(swipe_start.x - delta.x)
			set_v_scroll(swipe_start.y - delta.y)
			swipe_mouse_times.append(OS.get_ticks_msec())
			swipe_mouse_positions.append(ev.global_position)
			ev.position = Vector2.ZERO;
#			if scroll_vertical <= 0:
#				print("fin scroll acia arriba");
#			elif scroll_vertical >= 670:
#				print("fin scroll acia abajo");
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

