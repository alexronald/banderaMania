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
var cantGiros = 5
var random = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	lblCantidaGiro.text = str(cantGiros)
	btnGirar2.connect("pressed",self,"_on_btnGirar_pressed")
	pass # Replace with function body.

func btnAtras():
	if get_parent().has_method("cambiarMenuPricipal"):
		get_parent().cambiarMenuPricipal();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ruleta_area_entered(area):
	

	pass # Replace with function body.


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
		lblCantidaGiro.text = str(cantGiros)
	else:
		print("Girando")
	pass 
func girarRuleta()->void:
	tween.interpolate_property($ruleta,"rect_rotation",rotacionInicial,rotacionFinal,velosiad,0,1)
	tween.start()
	


func _on_areaClip_area_entered(area):
	if (area.name == "7" or area.name == "2"or area.name == "4") and tween.playback_speed <= 0.1:
		tween.playback_speed += 0.05
		print("ingrmento")

	$TwenClip.interpolate_property($clip,"rect_rotation",360,330,0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$TwenClip.start()
	yield($TwenClip,"tween_all_completed")
	$TwenClip.interpolate_property($clip,"rect_rotation",330,360,0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN)
	$TwenClip.start()
	yield($TwenClip,"tween_all_completed")
	$TwenClip.reset_all()
	btnPremio.text = ( area.name)
	pass # Replace with function body.


func _on_Timer_timeout():
	tween.playback_speed -= 0.1
	if tween.playback_speed <= 0:
		Ruleta_girando = false
		$clip/areaClip/CollisionShape2D.disabled = true
		tween.stop_all()
		tween.remove_all()
		tween.playback_speed = 1
		get_ruleta_rotacion_actual()
		obtenerPremio();
		$Timer.stop()
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
	
	pass
