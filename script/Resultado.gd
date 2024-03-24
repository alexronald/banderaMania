extends CanvasLayer
onready var textCoins=$Control/container/Container1/coin
onready var textScore=$Control/container/Container1/score
onready var progress = $ProgressBar
#onready var coins = $coinImage/CPUParticles2D;
#onready var tween = $Tween;
#onready var animetor = $animador;
var incremento= _Datos.recompensa;


func _ready():
	progresBar();
	iniciarGiro()
	guardarDatos();
	progresBar();
	darRecompensa();
	
	pass
func progresBar()->void:
	progress.max_value = _Datos.lista.size();
	var tween = Tween.new();
	add_child(tween)
	tween.interpolate_property(progress,"value",_Datos.data["desbloqueados"].size()-1,_Datos.data["desbloqueados"].size(),1,1,1)
	tween.start()
#	progress.value = _Datos.data["desbloqueados"].size();

func guardarDatos()->void:
	var des:Array = _Datos.data["desbloqueados"];
	
	if des.find(_Datos.nivel) == -1:
		_Datos.data["desbloqueados"].append(_Datos.nivel)
		des = _Datos.data["desbloqueados"]
		_Datos.save_data();
	else:
		print("nivel ya esta debloqueado")
		incremento= 0
		_Datos.escore=0
		
	if des.size() != _Datos.lista.size():
		print("juego incompleto")
	else:
		print_debug("juego complet")
#	if _Datos.nivel == _Datos.data["nivel"]:
#		_Datos.mensajebtn=false;
#		print("es igula")
#		if _Datos.nivel <= _Datos.data["nivel"]: ##cambiado para por ingula
#			_Datos.data["nivel"] +=1;
#			_Datos.save_data();
#			_Datos.nivel = _Datos.data["nivel"]
#		else:
#			_Datos.data["nivel"] = 0;
#			_Datos.save_data();
#			_Datos.nivel = 0;
#	else:
#		_Datos.nivel += 1;
#		incremento= 5;
func darRecompensa():
	_Datos.data["coins"]= _Datos.data["coins"]+incremento;
	_Datos.data["score"]= _Datos.data["score"]+_Datos.escore;
	_Datos.save_data()
	actualizarNodo()	
	_Datos.reniciarVariables()
	
func actualizarNodo():
	textScore.text = str(_Datos.data["score"]).pad_zeros(3);
func btnAtras():
	if get_parent().has_method("cambiarMenuNiveles"):
		get_parent().cambiarMenuNiveles();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")


func _on_Siguinte_pressed():
	if get_parent().has_method("cambiarMenuJuego"):
		_Datos.mensajebtn=false
		get_parent().cambiarMenuJuego();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
	pass # Replace with function body.


func _on_Timer_timeout():
	var coinsActual = _Datos.data["coins"]
	var coins = int(textCoins.text)
	if coins < coinsActual && coinsActual < 9999:
		coins += 1;
		if coinsActual+incremento > 9999:
			incremento = 9999 - coinsActual;
		textCoins.text=str(coins).pad_zeros(4);
	else:
		$Timer.stop();
	pass # Replace with function body.
func iniciarGiro():
	$tweengiraluz.interpolate_property($luz,"rect_rotation",0,360,3,0,0)
	$tweengiraluz.start()


func _on_tweengiraluz_tween_completed(object, key):
	iniciarGiro()
	pass # Replace with function body.
