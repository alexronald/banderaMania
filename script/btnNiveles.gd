extends TextureButton
onready var number = $number;
onready var spritestar = $Sprite
var ver = false
var miNivel=0;
var btnNivel = 0;
#signal clkic()
func _ready()->void:
	#btnNivel = int(name);
	number.text = str(btnNivel+1);
	#if btnNivel >= VARIABLES_DATOS.data["nivel"]+1:
#	if btnNivel >= 1:
#		number.visible = false;
#		disabled = true;
	spriteStartVisible()
	
	pass
func getTexture(newTexture)->void:
	texture_normal=load(newTexture)

func setNivel()->int:
	return miNivel;
	
func getNivel(newNivel)->void:
	miNivel=newNivel;
	number.text = str(newNivel);

func spriteStartVisible():
	spritestar.visible=ver;

func _on_btn1_pressed():
	Audiocontrol.activarEfectoUI()
	var controladorVista = get_tree().get_root().get_node("controladorVista")
	if controladorVista.has_method("cambiarMenuJuego"):
		_Datos.nivel = int(number.text);
		_Datos.mensajebtn=true
		controladorVista.cambiarMenuJuego();
		print("msag",_Datos.mensajebtn)
		controladorVista.get_child(0).queue_free()
	else:
		print(get_parent())
		print("ERROR NO SE ENCUENTRO EL METHODO")
	pass # Replace with function body.
