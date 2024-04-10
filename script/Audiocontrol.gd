extends Node

signal generarCambio;
onready var musica = $music
onready var efectoUI = $sonidoUi

var sonidoPositivo =preload("res://audio/positive.wav")
var sonidoNegativo = preload("res://audio/negative.wav")
var pressedBoton = preload("res://audio/glass.ogg")
var efectoGiro = preload("res://audio/jiro.ogg")
var efectoBonus =preload("res://audio/bonus.ogg")

func _ready():
	verificar_configuracion(_Datos.data["Musica"],musica);
	pass

func activarEfectoUI():
	efectoUI.stream = pressedBoton
	efectoUI.playing = _Datos.data["Sonido"]
	
	
func cambiarSonidi(tipoSonido):
	match tipoSonido:
		1:
			efectoUI.stream = sonidoPositivo
		2:
			efectoUI.stream = sonidoNegativo
		3:
			efectoUI.stream = efectoGiro
		4:
			efectoUI.stream = efectoBonus
	efectoUI.playing = _Datos.data["Sonido"]

func playEfectoUI():
	efectoUI.play()
	print(_Datos.data["Sonido"])
	
func activarMusica():
	musica.play()
	
func verificar_configuracion(datosAjuste, audioplayer):
	if datosAjuste:
		audioplayer.play()
	else:
		audioplayer.stop()
	
