extends CanvasLayer

onready var BtnGirar = $btnGirar
onready var tween = $Tween
onready var btnPremio = $btnPremios;
onready var lblCantidaGiro = $Panel/Container/lblCantiad
onready var txrRuleta = $ruleta
onready var btnGirar2 =$btnGirar2
var Ruleta_girando = false
var velosiad = 0.5;
var rotacionInicial
var rotacionFinal
var cantGiros = 0
var premios = {1:"50",2:"100",3:"20",4:"300",5:"3 Giros",6:"500",7:"1000",8:"2000"}
var premio = 3
var texturPremioicon = {}
var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	cargarAnuncios()
	conectarNodos()
	cantGiros = _Datos.data["giros"]
	cargarTextura();
	lblCantidaGiro.text = str(cantGiros)
	btnGirar2.connect("pressed",self,"giroGratis")
	pass # Replace with function body.

func btnAtras():
	if get_parent().has_method("cambiarMenuPricipal"):
		get_parent().cambiarMenuPricipal();
		queue_free()
	elif get_parent().has_method("volverDeMenuRuleta"):
		get_parent().volverDeMenuRuleta()
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_btnGirar_pressed():
	
	if !Ruleta_girando and cantGiros >= 1:
		get_velosiad_ramdom()
		$clip/areaClip/CollisionShape2D.disabled = false
		get_ruleta_rotacion_actual()
		girarRuleta()
		$Timer.start()
		tween.repeat = true
		Ruleta_girando = true
		cantGiros -= 1;
		_Datos.data["giros"] = cantGiros
		_Datos.save_data()
		lblCantidaGiro.text = str(cantGiros)
	elif cantGiros >= 0:
		giroGratis()
	else:
		print("Girando")
	pass 
func girarRuleta()->void:
	tween.interpolate_property($ruleta,"rect_rotation",rotacionInicial,rotacionFinal,velosiad,0,1)
	tween.start()
	

func _on_areaClip_area_entered(area):
	iniciarPrimerAnimacio();
	pass

func iniciarPrimerAnimacio():
	$TwenClip.interpolate_property($clip,"rect_rotation",360,330,0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$TwenClip.start()
	yield($TwenClip,"tween_all_completed")
	iniciarSegundaAnimacio()
	
func iniciarSegundaAnimacio():
	$TwenClip.interpolate_property($clip,"rect_rotation",330,360,0.2,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$TwenClip.start()
	yield($TwenClip,"tween_all_completed")
	$TwenClip.reset_all()

func _on_Timer_timeout():
	tween.playback_speed -= 0.05
	if tween.playback_speed <= 0:
		Ruleta_girando = false
		$clip/areaClip/CollisionShape2D.disabled = true
		tween.stop_all()
		tween.remove_all()
		tween.playback_speed = 1
		get_ruleta_rotacion_actual()
		obtenerPremio();
		$Timer.stop()
		cambiarEstadoBotnGirar()
	pass # Replace with function body.

func get_ruleta_rotacion_actual():
	rotacionFinal= txrRuleta.rect_rotation;
	if rotacionFinal < 0:
		rotacionFinal  = txrRuleta.rect_rotation + 360
	rotacionInicial= rotacionFinal-360;
	
	
func get_velosiad_ramdom():
	random.randomize()
	velosiad = random.randf_range(0.4,0.9);
	
func obtenerPremio():
	if premio != 5:
		_Datos.data["coins"] = _Datos.data["coins"] + int(premios[premio])
		_Datos.save_data()
		$Control.actualizarbtnCoin(_Datos.data["coins"])
		print("GANASTE ",int(premios[premio]))
		
	else:
		_Datos.data["giros"] = _Datos.data["giros"] + 3
		_Datos.save_data()
		cantGiros = _Datos.data["giros"]
		lblCantidaGiro.text = str(cantGiros)
		print("giros ",int(premios[premio]))
		
	pass
func giroGratis():
	if _AdMob.is_rewarded_video_loaded():
		_AdMob.show_rewarded_video()
	else:
		_AdMob.load_rewarded_video()
	print("ver ad")
	
func cambiarEstadoBotnGirar():
	
	if cantGiros <= 0:
		$btnGirar/Label.text = ""
		BtnGirar.texture_normal = load("res://recursos/btn_girar_ad.png")
#	else:
#		$btnGirar/Label.text = "$SPIN"
#		BtnGirar.texture_normal = load("res://recursos/btn_girar.png")
func _on_areaClip2_area_entered(area):
	btnPremio.text = premios[int(area.name)]
	btnPremio.icon = texturPremioicon[area.name]
	premio = int(area.name)
	pass # Replace with function body.

func cargarAnuncios()->void:
	#_AdMob.load_interstitial();
	_AdMob.load_rewarded_video();
	
func conectarNodos()->void:
	_AdMob.connect("interstitial_closed",self,"anunciocerrado");
	_AdMob.connect("rewarded_video_closed",self,"videoAnuncioCerrado")
	_AdMob.connect("rewarded_video_loaded",self,"mostrar")
	_AdMob.connect("interstitial_failed_to_load",self,"errorCargarAnuncio")

func videoAnuncioCerrado()->void:
	cargarAnuncios()
	_Datos.data["giros"] = _Datos.data["giros"]+1
	_Datos.save_data()
	cantGiros = _Datos.data["giros"]
	lblCantidaGiro.text = str(cantGiros)
	$btnGirar/Label.text = tr("$SPIN")
	BtnGirar.texture_normal = load("res://recursos/btn_girar.png")

func cargarTextura():
	texturPremioicon["1"]=preload("res://recursos/icon/50.png")
	texturPremioicon["2"]=preload("res://recursos/icon/100.png")
	texturPremioicon["3"]=preload("res://recursos/icon/20.png")
	texturPremioicon["4"]=preload("res://recursos/icon/300.png")
	texturPremioicon["5"]=preload("res://recursos/icon/3giros.png")
	texturPremioicon["6"]=preload("res://recursos/icon/500.png")
	texturPremioicon["7"]=preload("res://recursos/icon/1000.png")
	texturPremioicon["8"]=preload("res://recursos/icon/2000.png")


