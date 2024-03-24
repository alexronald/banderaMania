extends Control
onready var btnCoin = $Control/container/Container1/coin
onready var btncloseStore = $Control/container/containe2/btnCerrar
var adscontrol = AdsControl.new()
var recopensa = false

var tween = Tween.new()

func _ready():
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
func SignalsConnect()->void:
	btncloseStore.connect("pressed",self,"onBtnCloseStore")
	
	_AdMob.connect("interstitial_closed",self,"anunciocerrado");
	_AdMob.connect("rewarded_video_closed",self,"videoAnuncioCerrado")
	_AdMob.connect("rewarded_video_loaded",self,"mostrar")
	_AdMob.connect("interstitial_failed_to_load",self,"errorCargarAnuncio")
	pass
func onBtnCloseStore()->void:
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
	
func videoAnuncioCerrado()->void:
#	if recopensa :
#		_Datos.data["coins"] = _Datos.data["coins"]+60
#		_Datos.save_data()
#		btnCoin.text = str(_Datos.data["coins"]).pad_zeros(4)
#		_AdMob.load_rewarded_video();
#		recopensa = false
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
	pass # Replace with function body.


func _on_itemTikTok_pressed():
	OS.shell_open("https://www.tiktok.com/@andra.dev")
	pass # Replace with function body.


func _on_itemInstagram_pressed():
	OS.shell_open("https://www.instagram.com/andradev.oficial")
	pass # Replace with function body.


func _on_itemWhatsapp_pressed():
	OS.shell_open("https://api.whatsapp.com/send?text=hola,%20estoy%20jugando%20Bandera%20Mania%20puedes%20descargarlo%20de%20la%20google%20play...")
	pass # Replace with function body.


func _on_itemFlying_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.flyingsaucer")
	pass # Replace with function body.


func _on_itemQuizQuimica_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.quizquimica")
	pass # Replace with function body.


func _on_itemQuizEnglish_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=org.godotengine.quizenglish")
	pass # Replace with function body.
