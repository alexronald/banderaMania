extends CanvasLayer
onready var gridContainer = $ScrollContainer/CenterContainer/GridContainer
onready var btnNivele = preload("res://componentes/BtnNivel1.tscn")
func _ready():
	var index = 0
	for i in(_Datos.lista):
		print(_Datos.data["nivel"])
		var btnNiveleInstaciado = btnNivele.instance()
		btnNiveleInstaciado.name = str(i)
		btnNiveleInstaciado.getTexture("res://recursos/img/"+i+".png")
		if index <= _Datos.data["nivel"]:
			btnNiveleInstaciado.disabled = false
			btnNiveleInstaciado.modulate=Color("ffffff")
		gridContainer.add_child(btnNiveleInstaciado)
		btnNiveleInstaciado.getNivel(index)
		
		index += 1
	pass 

func btnAtras():
	if get_parent().has_method("cambiarMenuPricipal"):
		get_parent().cambiarMenuPricipal();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
		
func cam():
	print("Hello")
	pass
