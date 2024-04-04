extends Control
onready var btnCoin = $Control/container/Container1/coin
onready var btncloseStore = $Control/container/containe2/btnCerrar
onready var toasMsg=$Label;
onready var toasTween = $Label/toasTween

var adscontrol = AdsControl.new()
var nodoControlPrincipal;
var recopensa = false

var tween = Tween.new()
signal actulizar;

func _ready():
	nodoControlPrincipal=get_parent().get_node("Control")
	SignalsConnect();
	ControlarCoins()
	cargarAnuncios()
	btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
	add_child(tween)
	tween.interpolate_property(self,"rect_position",Vector2(0,-1170),Vector2(0,0),1,1,1)
	tween.start()
	pass
	
func ControlarCoins()->void:
	if _Datos.data["coins"] >= 10000:
		_Datos.data["coins"] = 9999;
		_Datos.save_data();
func actualizarVista():
	btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
	
func SignalsConnect()->void:
	btncloseStore.connect("pressed",self,"onBtnCloseStore")

	print(get_parent().get_node("Control").name)
	connect("actulizar",nodoControlPrincipal,"cambiarCoins")

	
	_AdMob.connect("interstitial_closed",self,"anunciocerrado");
	_AdMob.connect("rewarded_video_closed",self,"videoAnuncioCerrado")
	_AdMob.connect("rewarded_video_loaded",self,"mostrar")
	_AdMob.connect("interstitial_failed_to_load",self,"errorCargarAnuncio")
	pass
func onBtnCloseStore()->void:
	#emit_signal("actulizar")
	get_tree().paused = false;
	tween.interpolate_property(self,"rect_position",Vector2(0,0),Vector2(0,-1170),1,1,1)
	tween.start()
	if get_parent().has_method("volverDeMenuRuleta"):
		get_parent().volverDeMenuRuleta()
	yield(tween,"tween_completed")
	queue_free()


func _on_itemAdVerVideo_pressed():
	adscontrol.cargarMostraVideoAds()
#	recopensa = true
#	if _AdMob.is_rewarded_video_loaded():
#		_AdMob.show_rewarded_video()
#	else:
#		_AdMob.load_rewarded_video()
	pass 
	
#func videoAnuncioCerrado()->void:
##	if recopensa :
##		_Datos.data["coins"] = _Datos.data["coins"]+60
##		_Datos.save_data()
##		btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
##		_AdMob.load_rewarded_video();
##		recopensa = false
#
#	pass 
	
func videoAnuncioCerrado()->void:

	btnCoin.text = adscontrol.recompensaVideoAds()

func cargarAnuncios()->void:
	_AdMob.load_interstitial();
	_AdMob.load_rewarded_video();
	

func _on_itemAdBanner_pressed():
	if _AdMob.is_interstitial_loaded():
		_AdMob.show_interstitial()
		
	else:
		_AdMob.load_interstitial()
		_AdMob.show_interstitial()
	pass # Replace with function body.
	
func anunciocerrado()->void:
	_Datos.data["coins"] = _Datos.data["coins"]+30
	btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
	_Datos.save_data()
	_AdMob.load_interstitial();
	
#https://www.instagram.com/andradev.oficial/
#https://web.facebook.com/profile.php?id=100086531473650
#https://www.tiktok.com/@andra.dev
#https://api.whatsapp.com/send?text=hola,%20qué%20tal?


func _on_itemFacebook_pressed():
	OS.shell_open("https://web.facebook.com/profile.php?id=100086531473650")

	buscarLista(5,400)
	pass # Replace with function body.


func _on_itemTikTok_pressed():
	OS.shell_open("https://www.tiktok.com/@andra.dev")

	buscarLista(7,500)
	pass # Replace with function body.


func _on_itemInstagram_pressed():
	OS.shell_open("https://www.instagram.com/andradev.oficial")

	buscarLista(6,500)

	pass # Replace with function body.


func _on_itemWhatsapp_pressed():
	OS.shell_open("https://api.whatsapp.com/send?text=hola,%20estoy%20jugando%20Bandera%20Mania%20puedes%20descargarlo%20de%20la%20google%20play...")
	buscarLista(4,300)
	pass # Replace with function body.


func _on_itemFlying_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.flyingsaucer")

	buscarLista(3,100)
	pass # Replace with function body.


func _on_itemQuizQuimica_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.quizquimica")
	buscarLista(2,100)
	pass # Replace with function body.


func _on_itemQuizEnglish_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.quizenglish")

	pass # Replace with function body.

	buscarLista(1,100)
	pass # Replace with function body.

func buscarLista(idItem,recompesa)->bool:
	var lista:Array=_Datos.data["store"];
	if lista.find(idItem) != -1:
		mostrartoasMsg()
		print("se encontro en la lista")
	else:
		#lista.append(idItem);
		_Datos.data["store"].append(idItem)
		_Datos.data["coins"] += recompesa;
		_Datos.save_data()
		actualizarVista()
		emit_signal("actulizar")
		
		print("no se ubico elemento")
	return true
	
func mostrartoasMsg():
	toasMsg.visible = true
	toasTween.interpolate_property(toasMsg,"modulate",Color("00ffffff"),Color("ffffff"),2,1,0)
	toasTween.start();
	yield(toasTween,"tween_completed")
	toasTween.interpolate_property(toasMsg,"modulate",Color("ffffff"),Color("00ffffff"),2.5,1,0)
	toasTween.start();
	yield(toasTween,"tween_completed")
	toasMsg.visible = false
	pass
