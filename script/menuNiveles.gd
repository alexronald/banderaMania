extends CanvasLayer
#onready var gridContainer = $ScrollContainer/CenterContainer/GridContainer
#onready var btnNivele = preload("res://componentes/BtnNivel1.tscn")
#
#var des = []
#func _ready():
#	print(gridContainer.margin_top)
#	des = _Datos.data["desbloqueados"]
#	var bloqueado = true
#	var index = 0
#	for i in(_Datos.lista):
#		var btnNiveleInstaciado = btnNivele.instance()
#		btnNiveleInstaciado.name = str(i)
#		btnNiveleInstaciado.getTexture("res://recursos/img/"+i+".png")
#		btnNiveleInstaciado.disabled = false
#		if buscarnivel(index):
#		#if index <= _Datos.data["nivel"]:
#			btnNiveleInstaciado.ver = true
#			btnNiveleInstaciado.disabled = false
#			btnNiveleInstaciado.modulate=Color("ffffff")
#		gridContainer.add_child(btnNiveleInstaciado)
#		btnNiveleInstaciado.getNivel(index)
#		#btnNiveleInstaciado.spriteStartVisible(bloqueado)
#
#		index += 1
#
#	$ScrollContainer/CenterContainer/GridContainer.rect_min_size.y += gridContainer.rect_size.y+50
#	print(gridContainer.rect_size.y)
#	pass 
#
#func buscarnivel(index)->bool:
#	for i in des:
#		if i == index:
#			return true
#	return false
#
#func btnAtras():
#	if get_parent().has_method("cambiarMenuPricipal"):
#		get_parent().cambiarMenuPricipal();
#		queue_free()
#	else:
#		print(get_parent())
#		print("ERROR NO SE ENCUENTRO EL METHODO")
#
#func cam():
#	print("Hello")
#	pass

onready var gridContainer = $ScrollContainer/CenterContainer/GridContainer
onready var btnNivele = preload("res://componentes/BtnNivel1.tscn")
var niveCompletados = []
func _ready():
	niveCompletados = _Datos.data["desbloqueados"]
	var bloqueado = true
	for i in(_Datos.lista):
		var btnNiveleInstaciado = btnNivele.instance()
		btnNiveleInstaciado.name = str(i)
		btnNiveleInstaciado.getTexture("res://recursos/img/"+i+".png")
		btnNiveleInstaciado.disabled = false
		if niveCompletados.find(_Datos.lista.find(i)) != -1:
			btnNiveleInstaciado.ver = true
			btnNiveleInstaciado.disabled = false
			btnNiveleInstaciado.modulate=Color("ffffff")
		gridContainer.add_child(btnNiveleInstaciado)
		btnNiveleInstaciado.getNivel(_Datos.lista.find(i))
	pass 

func btnAtras():
	if get_parent().has_method("cambiarMenuPricipal"):
		get_parent().cambiarMenuPricipal();
		queue_free()
	else:
		print_debug("ERROR NO SE ENCUENTRO EL METHODO")
