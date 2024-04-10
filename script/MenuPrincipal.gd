extends CanvasLayer

onready var btnComenzar = $botones/btnComenzar
onready var btnMenuRuleta = $botones/btnGirar

func _ready():
	btnComenzar.connect("pressed",self,"menuJugar")
	btnMenuRuleta.connect("pressed",self,"menuRuleta")
	pass # Replace with function body.

func menuJugar()->void:
	Audiocontrol.activarEfectoUI()
	if get_parent().has_method("cambiarMenuNiveles"):
		get_parent().cambiarMenuNiveles();
		queue_free()
	else:
		print("ERROR NO SE ENCUENTRO EL METHODO")
		
func menuRuleta()->void:
	Audiocontrol.activarEfectoUI()
	if get_parent().has_method("cambiarMenuRuleta"):
		get_parent().cambiarMenuRuleta();
		queue_free()
	else:
		print("ERROR NO SE ENCUENTRO EL METHODO")
	
