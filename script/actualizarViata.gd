extends CanvasLayer
func _ready():
	if get_parent().has_method("cambiarMenuJuego"):
		_Datos.nivelAsignado=true
		get_parent().cambiarMenuJuego();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
	pass 


