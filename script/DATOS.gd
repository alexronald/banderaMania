extends Node

var doblesAlbunTemp;
var lista:Array=[
	"$BERILIO",
	"$ARSENICO",
	"$ASTATO",
	"$BARIO",
	"$BROMO"
];

var nivel = 0;
var mensajebtn = false;

const PATH = "user://data.dat"
const PASS = "abc123"

var is_loaded = false
var data = {
	"giros":5,
	"nivel":0,
	"coins":0,
	"rango":0,
	"score":0,
	"energia":0,
	"eliminarOpc":0,
	"tiempo":0,
	"Sonido":1,
	"Musica":1,
	"Notificacion":1,
	"Anuncio":1,
	"Lenguaje":0
}

func _ready():
	
	var file = File.new()
	
	if file.file_exists(PATH):
		#save_data()
		load_data()
	else:
		save_data()
		load_data()
	cambiarIdioma()
	nivel = data["nivel"];

func save_data():
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.WRITE, PASS)
	file.store_var(data)
	file.close()
	
	is_loaded = false

func load_data():
	if is_loaded:
		return
	
	var file = File.new()
	
	file.open_encrypted_with_pass(PATH, File.READ, PASS)
	data = file.get_var()
	file.close()
	
	is_loaded = true

func cambiarIdioma():
	match data["Lenguaje"]:
		0:
			TranslationServer.set_locale("es")
		1:
			TranslationServer.set_locale("en")
		2:
			TranslationServer.set_locale("pt")
