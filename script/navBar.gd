extends Control

var menuAjuste = preload("res://vista/MenuAjuste.tscn")
var viewStore = preload("res://vista/viewStore.tscn")


onready var btnScore = $container/Container1/score;
onready var btnCoin = $container/Container1/coin;
onready var btnAjuste = $container/Container1/Ajuste;
onready var lblTitulo = $container/containe2/Titulo
onready var container2 = $container/containe2

signal sigBtnAtras()
func _ready():
	get_node_padre(get_parent().name)
	print(get_parent().name)
	#container.rect_scale = Vector2(0.9,0.9)
	print(get_viewport_rect().size)
	conectarSenales()
	ControlarCoins();
	btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
	pass 

func ControlarCoins()->void:
	if _Datos.data["coins"] >= 10000:
		_Datos.data["coins"] = 9999;
		_Datos.save_data();

func cambiarCoins():
	print("señalresivida")
	pass
func onBtnCoinStore():
	print("viewStore")
	var instViewStore = viewStore.instance();
	get_parent().add_child(instViewStore)
	get_tree().paused = !get_tree().paused;

func conectarSenales()->void:
	btnAjuste.connect("pressed",self,"pressedBtnAjustes")
	btnCoin.connect("pressed",self,"onBtnCoinStore")
	
func pressedBtnAjustes()->void:
	print("MENU AJUSTE")
#	AudioControl.activarEfectoUI()
	var instMenuAjuste = menuAjuste.instance();
	get_parent().add_child(instMenuAjuste)
	get_tree().paused = !get_tree().paused;
#	if get_parent().has_method("audioTiempo"):#comprovamos si el metodo existe
#		menuAjuste.connect("cambioEstado",get_parent(),"audioTiempo") #emite señal de MenuAjuste Y lo conectamos MenuJuego

func get_node_padre(nodo_padre):
	match nodo_padre:
		"MenuPrincipal":
			container2.visible = false
			$container.alignment= HALIGN_RIGHT
		"menuNiveles":
			container2.visible = true
			$container.alignment= HALIGN_CENTER
		"MenuJuego":
			lblTitulo.text = str(_Datos.nivel+1);
		"Resultado":
			lblTitulo.text = "Resultado"
		"viewStore":
			btnCoin.disabled = true;
			lblTitulo.text = "$STORE"
		"MenuRuleta":
			lblTitulo.text = "$GIRAR"
	pass
	
func _on_Button_pressed():
	self.connect("sigBtnAtras",get_parent(),"btnAtras")
	emit_signal("sigBtnAtras");
