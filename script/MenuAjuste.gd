extends Control
var presed
var tween = Tween.new();
signal cambioEstado();

func _ready():
	posicionInicial()
	$VBoxContainer/cbMusica.pressed = _Datos.data["Musica"]
	$VBoxContainer/cbNotificacion.pressed = _Datos.data["Notificacion"]
	$VBoxContainer/cbSonido.pressed = _Datos.data["Sonido"];
	$VBoxContainer/obIdiona.selected = _Datos.data["Lenguaje"]
	add_child(tween)
	tween.interpolate_property(self,"rect_position",Vector2(540,0),Vector2(85,0),1,1,1)
	tween.start()
	#_AdMob.connect("interstitial_failed_to_load",self,"falseAnuncio")
	pass 
	
func posicionInicial()->void:
	self.rect_position = Vector2(0,0)



func _on_btnAtras_pressed():
	get_tree().paused = !get_tree().paused
	tween.interpolate_property(self,"rect_position",Vector2(210,0),Vector2(600,0),1,1,1)
	tween.start()
	guardarAjuste()
	emit_signal("cambioEstado")
	yield(tween,"tween_completed")
	queue_free()
	pass # Replace with function body.
func guardarAjuste()->void:
	_Datos.data["Sonido"]=int($VBoxContainer/cbSonido.pressed)
	_Datos.data["Musica"]=int($VBoxContainer/cbMusica.pressed)
	_Datos.data["Notificacion"]=int($VBoxContainer/cbNotificacion.pressed)
	_Datos.data["Lenguaje"] = $VBoxContainer/obIdiona.selected
	_Datos.save_data()
	#
	_Datos.cambiarIdioma()
	#AudioControl.activarEfectoUI()
