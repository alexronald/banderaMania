extends Node2D
var adsControl:AdsControl = AdsControl.new()

# Lista de viastas
var menuPrincipal = preload("res://vista/MenuPrincipal.tscn")
var menuJugar = preload("res://vista/MenuJuego.tscn")
var menuNiveles = preload("res://vista/menuNiveles.tscn")
var menuResultado = preload("res://vista/Resultado.tscn")
var menuRuleta = preload("res://vista/MenuRuleta.tscn")

func _ready():
	cambiarMenuPricipal()
	_AdMob.load_banner()
	if _AdMob._admob_singleton == null:
		#print("actibarBaner")
		_AdMob.show_banner();
	else:
		_AdMob.load_banner()
		_AdMob.show_banner();
		
	adsControl.cargarMostraInterstitialAds();
	pass
#func _process(delta):
#	print(Engine.get_frames_per_second())
#	print(OS.get_static_memory_usage())

func  cambiarMenuPricipal()->void:
	add_child(menuPrincipal.instance())
	pass

func cambiarMenuJuego()->void:
	if get_tree().paused:
		get_tree().paused = !get_tree().paused
	add_child(menuJugar.instance())
	
#func recrearMenuJuego(idNivel):
#	var controladorVista = get_tree().get_root().get_node("controladorVista")
#	_Datos.nivel = int(idNivel);
#	_Datos.mensajebtn=true
#	controladorVista.get_child(0).queue_free()
#	if get_tree().paused:
#		get_tree().paused = !get_tree().paused
#	add_child(menuJugar.instance())
	
func cambiarMenuNiveles()->void:
	if get_tree().paused:
		print("pause")
		get_tree().paused = !get_tree().paused
	add_child(menuNiveles.instance())

func cambiarMenuResultado()->void:
	if get_tree().paused:
		print("pause")
		get_tree().paused = !get_tree().paused
	add_child(menuResultado.instance())
	randomize()
	if (randi()%21) % 2:
		adsControl.cargarMostraInterstitialAds()

func cambiarMenuRuleta()->void:
	if get_tree().paused:
		print("pause")
		get_tree().paused = !get_tree().paused
	add_child(menuRuleta.instance())
	adsControl.cargarMostraInterstitialAds()


