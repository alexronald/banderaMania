extends TextureButton

onready var tween:Tween = $Tween;
onready var letra:String = $letra.text setget setLetra,getLetra;
var posicionColocado setget setPosicionColocado, getPosicionColocado;
var presionado = false setget setPresionado, getPresionado;
var posisionInicial:Vector2  #Vector2.ZERO# setget setPosicionInicial, getPosicionInicial;
var posicionFinal:Vector2 = Vector2.ZERO setget setPosicionFinal, getPosicionFinal;
func _ready():
	pass # Replace with function body.

func setPosicionFinal(newPosicionFinal:Vector2)->void:
	posicionFinal = newPosicionFinal;

func getPosicionFinal()->Vector2:
	return posicionFinal;
	
func setPosicionInicial()->void:
	if(posisionInicial == Vector2(0,0)):
		posisionInicial = self.rect_global_position;
	pass

func setPosicionColocado(newPosicionColocado:int)->void:
	posicionColocado = newPosicionColocado;

func getPosicionColocado()->int:
	return posicionColocado;

func getPosicionInicial()->Vector2:
	return posisionInicial;

func setPresionado(newPresion:bool)->void:
	Audiocontrol.activarEfectoUI()
	presionado = newPresion;

func getPresionado()->bool:
	return presionado;

func TrancicionIr()->void:
	tween.interpolate_property(self, "rect_global_position", posisionInicial, posicionFinal,0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale", Vector2(1,1),Vector2(0.7,0.7), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start();

func TrancicionVolver()->void:
	tween.interpolate_property(self, "rect_global_position", posicionFinal, posisionInicial,0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale",Vector2(0.7,0.7),Vector2(1,1), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start();

func setLetra(newLetra:String)->void:
	letra = newLetra;
	$letra.text = letra;

func getLetra()->String:
	return letra;

func setPesedDisable(newDisable:bool)->void:
	self.disabled=newDisable

