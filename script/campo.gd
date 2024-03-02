extends TextureRect
var campoVacio = true setget setCampoVacio, getCampoVacio;
var campoDefinido = false setget setCampoDefinido,getCampoDefinido
func _ready():
	pass 

func setCampoVacio(newCampoVacio:bool)->void:
	campoVacio = newCampoVacio;

func getCampoVacio()->bool:
	return campoVacio;

func setCampoDefinido(newDefinir:bool)->void:
	campoDefinido = newDefinir;
func getCampoDefinido()->bool:
	return campoDefinido;
