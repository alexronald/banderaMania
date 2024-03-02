extends CanvasLayer

var texture:Texture;
onready var imagenMostrar:TextureRect = $imagenMostrar;
onready var tween:Tween = $Tween;
onready var TextCoins = $Control/container/Container1/coin
onready var GridBtn:GridContainer = $GridLetras;

onready var menuPistas = $viewPista;
onready var btnPista = $btnPista;
onready var btnResolver = $viewPista/btnContainer/btnResolver
onready var btnLetraAleatoria = $viewPista/btnContainer/btnLetraAleatoria
onready var btnEleminarLetra = $viewPista/btnContainer/btnEleminarLetra
onready var btnCerrarViewPista = $viewPista/btnCerrar
onready var textNivel = Label.new();
#onready var textNivel = $barra/ColorRect/nivel/textnivel;
var testura:Resource = load("res://vista/campo.tscn")
var respuetas:String;
var resultado:String;
var botones:Array;
var contadorCompleto:int=1;
var campoLLeno:bool = false
onready var campos:Array;

var nivel = 1
#var mensajebtn = false

func btnAtras():
	if get_parent().has_method("cambiarMenuNiveles"):
		get_parent().cambiarMenuNiveles();
		queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")


func _ready():
	conectarSIgnal()
	add_child(textNivel)
	print("nivel es ",nivel);
	if !_Datos.mensajebtn:
		print("msg",_Datos.mensajebtn)
		setNivel()
	else:
		
		GridBtn.starGame();
		#_Datos.mensajebtn = false;
	#_Datos.nivel = 1
	textNivel.text = str(_Datos.nivel+1);
	respuetas = tr(_Datos.lista[_Datos.nivel])
	botones = get_tree().get_nodes_in_group("botones");
	conectar();
	instanciar();
	campos = get_tree().get_nodes_in_group("campo");
	imagenMostrar.texture=load("res://recursos/img/"+_Datos.lista[_Datos.nivel]+".png")
	pass
func conectarSIgnal()->void:
	btnPista.connect("pressed",self,"btnPistaMostrar")
	btnCerrarViewPista.connect("pressed",self,"btnCerrarViewPistaHide")
	btnResolver.connect("pressed",self,"_on_resolver_pressed")
	btnEleminarLetra.connect("pressed",self,"_on_eliminarLetra_pressed")
	btnLetraAleatoria.connect("pressed",self,"_on_letraAleatorio_pressed")
	
func conectar()->void:
	var letras:String = GridBtn.revolverLettra()
	var index = 0;
	for boton in botones:
		boton.connect("pressed",self,"pressed",[boton])
		boton.setLetra(letras[index])
		print(letras[index])
		boton.texture_normal = load("res://recursos/basico/"+letras[index]+".png");
		index += 1;
	
func pressed(boton):
#	if campoLLeno:
#		return;
	if(!boton.getPresionado()):
		boton.setPosicionInicial();
		var pos = 0
		for campo in campos:
			if campo.getCampoVacio():
				campo.setCampoVacio(false);
				boton.setPosicionColocado(pos)
				boton.setPosicionFinal(campo.rect_global_position)
				boton.setPresionado(true)
				boton.TrancicionIr();
				resultado[boton.getPosicionColocado()] = boton.getLetra();
				comprobarResultado()
				contadorCompleto += 1;
				break
			pos += 1;
			
	elif boton.getPresionado():
		var botoPos = boton.getPosicionColocado()
		var pos = 0;
		for campo in campos:
			if pos == botoPos:
				campo.setCampoVacio(true);
				boton.setPresionado(false)
				boton.TrancicionVolver();
				contadorCompleto -= 1;
				resultado[boton.getPosicionColocado()] = str(boton.getPosicionColocado())
				break
			pos += 1;

func instanciar()->void:
	for i in respuetas.length():
		$respuesta.add_child(testura.instance());
		resultado += str(i+1)


#func _on_btnPista_pressed():
#	menuPistas.show();
#	get_tree().paused=true;
#	pass 
func btnPistaMostrar():
	menuPistas.show();
	get_tree().paused=true;
	pass 
	
func completar()->void:
	var array = GridBtn.getIndexLettrasCorrectas();
	if array:
		var posicion = randi()%array.size()
		var pos = 0;
		botones[array[posicion]].setPosicionInicial();
		for letra in respuetas:
			if campos[pos].getCampoVacio() && !botones[array[posicion]].getPresionado() :
				if botones[array[posicion]].getLetra() == letra:
					campos[pos].setCampoVacio(false);
					botones[array[posicion]].setPosicionColocado(pos)
					botones[array[posicion]].setPosicionFinal(campos[pos].rect_global_position)
					botones[array[posicion]].setPresionado(true)
					botones[array[posicion]].TrancicionIr();
					resultado[botones[array[posicion]].getPosicionColocado()] = botones[array[posicion]].getLetra();
					botones[array[posicion]].modulate = "97e807"
					botones[array[posicion]].disabled=true;
					comprobarResultado()
					contadorCompleto += 1;
					break
			pos += 1;
		array.remove(posicion)
		print(array)
	else:
		print ("eso es todo");

func revicion()->void:
	var index = GridBtn.getIndexLettrasCorrectas();
	for i in range(index.size()):
		for letra in resultado:
			if botones[index[i]].getLetra()==letra:
				print(letra)
				print(i)
	pass

func eliminarLetrasSobrante()->void:
	var array:Array=GridBtn.getIndexLetrasInfiltrados();
	if array:
		var posicion = randi()%array.size();
		botones[array[posicion]].disabled=true;
		botones[array[posicion]].modulate="55ffffff";
		array.remove(posicion)
		print("hay contenido")
	else:
		print("no hay contenido")


func resolver()->void:
	var nuevoArray;
	var pos = 0;
	for letra in respuetas:
		for boton in botones:
			boton.setPosicionInicial();
			if letra == boton.getLetra():
				if !boton.getPresionado():
					campos[pos].setCampoVacio(false);
					boton.setPosicionColocado(pos)
					boton.setPosicionFinal(campos[pos].rect_global_position)
					boton.setPresionado(true)
					boton.TrancicionIr();
					resultado[boton.getPosicionColocado()] = boton.getLetra();
					comprobarResultado()
					print(letra)
					pos +=1
					break
			
pass

func comprobarResultado()->void:
	if resultado == tr(_Datos.lista[_Datos.nivel]):
#		if _Datos.nivel <= _Datos.data["nivel"]:
#				_Datos.data["nivel"] +=1;
#				_Datos.save_data();
		efectoletras("ffffff","#92ff7c")
		yield(tween,"tween_all_completed");
		efectoletras("#92ff7c","#92ff7c")
		yield(tween,"tween_all_completed");
		mostrarResultado();
		
	else:
		if contadorCompleto >= resultado.length():
			print("INCORRECTO")
			efectoletras("#ff7272","#00ffffff")
			yield(tween,"tween_all_completed");
			efectoletras("#ff7272","#ffffff")
			yield(tween,"tween_all_completed");
			$Label.text = "incorrecto"
		else:
			print("incompleto");
			print(resultado.length())
			print(contadorCompleto)
			pass

func mostrarResultado()->void:
	if get_parent().has_method("cambiarMenuResultado"):
		get_parent().cambiarMenuResultado();
		queue_free()
	else:
		print("ERROR NO SE ENCUENTRO EL METHODO")
	
func efectoletras(color1,color2)->void:
	for boton in botones:
		if boton.getPresionado() :
			tween.interpolate_property(boton,"self_modulate",Color(color1),Color(color2),0.4,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN);
	tween.start();
	pass

func _on_TextureButton_pressed():
	if get_tree().change_scene("res://menu/menuPrincipal.tscn")!=OK:
		print("error")
	pass 

func limpiar()->void:
	for boton in botones:
		if boton.getPresionado():
			boton.modulate ="ffffff";
			boton.disabled=false;
			campos[boton.getPosicionColocado()].setCampoVacio(true);
			boton.setPresionado(false)
			resultado[boton.getPosicionColocado()] = str(boton.getPosicionColocado())
			boton.TrancicionVolver();
			contadorCompleto -= 1;
			print("volver")

func limpiarNoDisable()->void:
	for boton in botones:
		if boton.getPresionado() && !boton.disabled:
			boton.modulate ="ffffff";
			campos[boton.getPosicionColocado()].setCampoVacio(true);
			boton.setPresionado(false)
			resultado[boton.getPosicionColocado()] = str(boton.getPosicionColocado())
			boton.TrancicionVolver();
			contadorCompleto -= 1;
			print("volver")

func setNivel()->void:
	if _Datos.nivel < _Datos.lista.size():
		_Datos.nivel = _Datos.data["nivel"];
	else:
		_Datos.nivel = 0;
		_Datos.data["nivel"]=0;
		_Datos.save_data();
	GridBtn.starGame();


#func _on_cerrar_pressed():
#	menuPistas.hide();
#	get_tree().paused=false;
#	pass 
func btnCerrarViewPistaHide()->void:
	menuPistas.hide();
	get_tree().paused=false;

func _on_eliminarLetra_pressed():
	var coins=int(TextCoins.text);
	if coins >= 80:
		coins -= 80;
		menuPistas.hide();
		get_tree().paused=false;
		eliminarLetrasSobrante()
		realizarCompra(2,coins)
	else:
		$Control.onBtnCoinStore();
		errorCompra();
	pass


func _on_resolver_pressed():
	var coins=int(TextCoins.text);
	if coins >= 120:
		coins -= 120;
		menuPistas.hide();
		get_tree().paused=false;
		limpiar();
		realizarCompra(3,coins);
		resolver()
	else:
		errorCompra();
	pass

func _on_letraAleatorio_pressed():
	var coins=int(TextCoins.text);
	if coins >= 50:
		coins -= 50;
		menuPistas.hide();
		get_tree().paused=false;
		limpiarNoDisable()
		completar()
		realizarCompra(1,coins)
	else:
		errorCompra()
	pass
	
func errorCompra()->void:
	print("EFECTO")
	tween.reset_all()
	menuPistas.modulate = "#ffffff"
	tween.interpolate_property(menuPistas,"modulate",Color("#ffffff"),Color("#fe8b8b"),0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN);
	tween.start();
	yield(tween,"tween_all_completed");
	tween.interpolate_property(menuPistas,"modulate",Color("#fe8b8b"),Color("#ffffff"),0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT_IN);
	tween.start();
	yield(tween,"tween_all_completed");
	tween.reset_all()
	

func realizarCompra(codigo:int,coins:int)->void:
	TextCoins.text = str(coins).pad_zeros(4)
	_Datos.data["coins"]=coins;
	_Datos.save_data();
