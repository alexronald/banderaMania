extends TextureRect

signal estadoButton(confirmar)

onready var titulo = $title;
onready var mensaje = $message;
onready var btnMasTarde = $btnMasTarde;
onready var btnIrAhora =$btnIrAhora;
var idRecompensa

func _ready():
	pass 

func setDatos(newTitle,newMensaje,newIdRecompensa):
	titulo.text = newTitle;
	mensaje.text = tr(newMensaje);
	idRecompensa=newIdRecompensa
	


func _on_btnMasTarde_pressed():
	Audiocontrol.activarEfectoUI()
	emit_signal("estadoButton",0)
	queue_free()
	pass 


func _on_btnIrAhora_pressed():
	Audiocontrol.activarEfectoUI()
	emit_signal("estadoButton",idRecompensa)
	queue_free()
	pass # Replace with function body.
