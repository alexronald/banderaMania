extends TouchScreenButton

signal deslizar_derecha()
signal deslizar_izquierda()

var touch_posicion_inicial = Vector2.ZERO
func _ready():
	self.connect("pressed",self,"_on_touch_preseed")
	self.connect("released",self,"_on_touch_released")
	pass # Replace with function body.

func _on_touch_preseed():
	touch_posicion_inicial = self.get_global_mouse_position()
	#print("preset touch")

func _on_touch_released():
	var touch_posicion_final = self.get_global_mouse_position()
	var drag_distancia=touch_posicion_final-touch_posicion_inicial
	#print("released touch", touch_posicion_final,"distanci ",drag_distancia)
	if touch_posicion_inicial.x != touch_posicion_final.x:
		#print("no se movio nada")
		if abs(drag_distancia.x) > abs(drag_distancia.y):
			if drag_distancia.x>0:
				emit_signal("deslizar_izquierda")
				print("derecha")
			else:
				emit_signal("deslizar_derecha")
				print("izquierda")
	else:
		if touch_posicion_inicial.x > 0 and touch_posicion_inicial.x<200:
			emit_signal("deslizar_izquierda")
			print("emitiendo señal deslizar_derecha")
		elif touch_posicion_inicial.x > 340 and touch_posicion_inicial.x<540:
			emit_signal("deslizar_derecha")
			print("emitiendo señal deslizar_izquierda")
	
