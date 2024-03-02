extends CanvasLayer
onready var textCoins=$Control/container/Container1/coin
onready var progress = $ProgressBar
#onready var coins = $coinImage/CPUParticles2D;
#onready var tween = $Tween;
#onready var animetor = $animador;
var incremento= 20


func _ready():
	progresBar();
	guardarDatos();
	#animetor.current_animation="animacioresultado";
	#animetor.play();
	#yield(animetor,"animation_finished");
	#coins.emitting=true;
	progresBar();
	#animetor.current_animation="strellas";
	#animetor.play();
	pass
func progresBar()->void:
	progress.max_value = _Datos.lista.size();
	progress.value = _Datos.nivel;

func guardarDatos()->void:
	if _Datos.nivel == _Datos.data["nivel"]:
		_Datos.mensajebtn=false;
		print("es igula")
		if _Datos.nivel <= _Datos.data["nivel"]: ##cambiado para por ingula
			_Datos.data["nivel"] +=1;
			_Datos.save_data();
			_Datos.nivel = _Datos.data["nivel"]
		else:
			_Datos.data["nivel"] = 0;
			_Datos.save_data();
			_Datos.nivel = 0;
	else:
		_Datos.nivel += 1;
		incremento= 5;

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
	if coins < coinsActual+incremento && coinsActual < 9999:
		coins += 1;
		if coinsActual+incremento > 9999:
			incremento = 9999 - coinsActual;
		textCoins.text=str(coins).pad_zeros(4);
	else:
		$Timer.stop();
		coins = int(textCoins.text)
		_Datos.data["coins"]=coins;
		_Datos.save_data();
	pass # Replace with function body.
