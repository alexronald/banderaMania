extends GridContainer


var letras:String="abcdefghijklmnopqrstuvwxyz";
var letrasElegidas:String;
var indexLetrasInfiltrados:Array;
var indexLettrasCorrectas:Array;

func _ready():
	pass 
	
func starGame()->void:
	#print("nivel"+str(VARIABLES_DATOS.nivel))
	#letrasElegidas = tr(VARIABLES_DATOS.lista[VARIABLES_DATOS.nivel])#<---nivel
	letrasElegidas = tr(_Datos.lista[_Datos.nivel])
	letrasElegidas += letrasAleatorioas();
	letrasAleatorioas()
	
func letrasAleatorioas()-> String:
	var nuevasLetras:String;
	var cantBotones = self.get_child_count();
	for i in range(cantBotones-tr(_Datos.lista[_Datos.nivel]).length()):
	#for i in range(12-_Datos.lista[_Datos.nivel].length()):
		randomize();
		var num = randi()%letras.length();
		nuevasLetras += letras[num]
	return nuevasLetras;

func revolverLettra()->String:
	var letraRevolvido:String;
	var indexLista:Array = range(letrasElegidas.length())
	#var tamano = tr(VARIABLES_DATOS.lista[VARIABLES_DATOS.nivel]).length();
	var tamano = tr(_Datos.lista[_Datos.nivel]).length();
	print(tamano)
	var i = 0;
	for letra in range(letrasElegidas.length()):
		randomize();
		var valor = randi()%indexLista.size();
		letraRevolvido += letrasElegidas[indexLista[valor]];
		if indexLista[valor] >= tamano:
			indexLetrasInfiltrados.append(i);
		else:
			indexLettrasCorrectas.append(i);
		indexLista.remove(valor);
		i+=1;
	return letraRevolvido;
	pass

func getIndexLetrasInfiltrados()->Array:
	return indexLetrasInfiltrados;
	
func setIndexLetrasInfiltrados(newIndexLetrasInfiltrados)->void:
	indexLetrasInfiltrados = newIndexLetrasInfiltrados;


func getIndexLettrasCorrectas()->Array:
	return indexLettrasCorrectas;

func setIndexLettrasCorrectas(newIndexLettrasCorrectas)->void:
	indexLettrasCorrectas=newIndexLettrasCorrectas;
	
