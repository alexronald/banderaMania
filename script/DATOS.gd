extends Node

var doblesAlbunTemp;
var lista:Array=[
	"$ANGOLA",
	"$ARGELIA",
	"$BENIA",
	"$BOTSUANA",
	"$BURKINAFASO",
	"$BURUNDI",
	"$CABOVERDE",
	"$CAMERUN",
	"$CHAD",
	"$COMORAS",
	"$COSTADEMARFIL",
	"$EGIPTO",
	"$ESUATINI",
	"$ETIOPIA",
	"$GABON",
	"$GAMBIA",
	"$GHANA",
	"$GUINEABISSAU",
	"$GUINEA",
	"$KENIA",
	"$LESOTO",
	"$LIBERIA",
	"$LIBIA",
	"$MADAGASCAR",
	"$MALAUI",
	"$MALI",
	"$MARRUECOS",
	"$MAURICIO",
	"$MAURITANIA",
	"$MOZAMBIQUE",
	"$NAMIBIA",
	"$NIGER",
	"$NIGERIA",
	"$SOMALILANDIA",
	"$REUNION",
	"$RUANDA",
	"$SENEGAL",
	"$SEYCHELLES",
	"$SIERRALEONA",
	"$SOMALIA",
	"$SUDAFRICA",
	"$SUDAN",
	"$SUDANDELSUR",
	"$TANZANIA",
	"$TOGO",
	"$TUNEZ",
	"$UGANDA",
	"$YIBUTI",
	"$ZAMBIA",
	"$ZIMBABUE",

	"$GUINEAECUATORIAL",
	"$REPUBLICACENTROAFRICANA",
	"$REPUBLICADELCONGO",
	#"$REPUBLICADEMOCRATICADELCONGO",
	#"$REPUBLICADEMOCRATICADELCONGO",
	"$SAHARAOCCIDENTAL",
	"$SANTOTOMEYPRINCIPE",
];

var nivel = 0;
var recompensa=20;
var escore = 3;
var mensajebtn = false;

const PATH = "user://data.dat"
const PASS = "abc123"

var is_loaded = false
var data = {
	"giros":5,
	"nivel":0,
	"coins":0,
	"rango":10,
	"score":0,
	"desbloqueados":[],
	"store":[],
	"eliminarOpc":0,
	"tiempo":0,
	"Sonido":1,
	"Musica":1,
	"Notificacion":1,
	"Anuncio":1,
	"Lenguaje":0,
	"juegoCompleto":false
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
	
func reniciarVariables():
	recompensa = 20
	escore=3

func cambiarIdioma():
	match data["Lenguaje"]:
		0:
			TranslationServer.set_locale("es")
		1:
			TranslationServer.set_locale("en")
		2:
			TranslationServer.set_locale("pt")
