extends Control

@export var client_id : String = "xlthn6ephh6cfcx2hculewt8b37ks9" #nota, cambiar cuando exporte el proyecto final
@export var channel : String
@export var username : String

#var nombre_temporal = "probando"
var id : TwitchIDConnection
var api : TwitchAPIConnection
var irc : TwitchIRCConnection
var eventsub : TwitchEventSubConnection

var cmd_handler : GIFTCommandHandler = GIFTCommandHandler.new()
var iconloader : TwitchIconDownloader

func _ready() -> void:
	pass

func hello(cmd_info : CommandInfo) -> void:
	irc.chat("Hello World!")

func list(cmd_info : CommandInfo, arg_ary : PackedStringArray) -> void:
	irc.chat(", ".join(arg_ary))

func on_event(type : String, data : Dictionary) -> void:
	match(type):
		"channel.follow":
			print("%s followed your channel!" % data["user_name"])

func send_message() -> void:
	irc.chat(%LineEdit.text)
	%LineEdit.text = ""

func put_chat(senderdata : SenderData, msg : String):
	var bottom : bool = %ChatScrollContainer.scroll_vertical == %ChatScrollContainer.get_v_scroll_bar().max_value - %ChatScrollContainer.get_v_scroll_bar().get_rect().size.y
	var label : RichTextLabel = RichTextLabel.new()
	var time = Time.get_time_dict_from_system()
	label.fit_content = true
	label.selection_enabled = true
	label.push_font_size(12)
	label.push_color(Color.WEB_GRAY)
	label.add_text("%02d:%02d " % [time["hour"], time["minute"]])
	label.pop()
	label.push_font_size(14)
	var badges : Array[Texture2D]
	for badge in senderdata.tags["badges"].split(",", false):
		label.add_image(await(iconloader.get_badge(badge, senderdata.tags["room-id"])), 0, 0, Color.WHITE, INLINE_ALIGNMENT_CENTER)
	label.push_bold()
	if (senderdata.tags["color"] != ""):
		label.push_color(Color(senderdata.tags["color"]))
	label.add_text(" %s" % senderdata.tags["display-name"]) #aca esta el username de quien mando un mensaje, esto usarlo para diferenciar cada personaje
#	nombre_temporal =senderdata.tags["display-name"] #IMPORTANTISIMO, aca se guarda el nombre del usuario para usarse en funciones como join
	label.push_color(Color.WHITE)
	label.push_normal()
	label.add_text(": ")
	var locations : Array[EmoteLocation] = []
	if (senderdata.tags.has("emotes")):
		for emote in senderdata.tags["emotes"].split("/", false):
			var data : PackedStringArray = emote.split(":")
			for d in data[1].split(","):
				var start_end = d.split("-")
				locations.append(EmoteLocation.new(data[0], int(start_end[0]), int(start_end[1])))
	locations.sort_custom(Callable(EmoteLocation, "smaller"))
	if (locations.is_empty()):
		label.add_text(msg)
	else:
		var offset = 0
		for loc in locations:
			label.add_text(msg.substr(offset, loc.start - offset))
			label.add_image(await(iconloader.get_emote(loc.id)), 0, 0, Color.WHITE, INLINE_ALIGNMENT_CENTER)
			offset = loc.end + 1
	%Messages.add_child(label)
	await(get_tree().process_frame)
	if (bottom):
		%ChatScrollContainer.scroll_vertical = %ChatScrollContainer.get_v_scroll_bar().max_value

class EmoteLocation extends RefCounted:
	var id : String
	var start : int
	var end : int

	func _init(emote_id, start_idx, end_idx):
		self.id = emote_id
		self.start = start_idx
		self.end = end_idx

	static func smaller(a : EmoteLocation, b : EmoteLocation):
		return a.start < b.start


func conexion_exitosa_esconder_botones():
	print("CONEXION EXITOSA")
	#$CanvasLayer.hide() #agregar los botones restantes al final
	#$AudioSonido.play()

func conexion_fallida_mostrar_botones():
	print("CONEXION FALLIDA")
	#$CanvasLayer.show()
	#$AudioErrorYaUnido.play() #solo debug
#-----######-------------------- COMANDOS DEL CHAT ---------------------------######----------


func probando(cmd_info : CommandInfo):
	print("SE ESCRIBIO EL MENSAJE PROBANDO EN EL CHAT, SI VES ESTO ENTONCES FUNCIONA!!!")


#func join(cmd_info : CommandInfo):
	#if !Global.hay_lugar_lobby() or !Global.lobby_esta_abierto(): #si no hay lugar o el lobby esta cerrado
		#print("No hay lugar, return")
		#return
	#var nombre_usuario : String = cmd_info.sender_data.user
	#var canal := cmd_info.sender_data.channel
	#var tag_valor = cmd_info.sender_data.tags
	#var tag_moderador = tag_valor["mod"]
	#var color = tag_valor["color"]
	#print("El color vale: ", color) #esta en codigo #2E8B57 , todavia no defino si lo voy a usar
	#var es_moderador: bool = false
	#print("NOMBRE DE USUARIO VALE: ", nombre_usuario)
	#print("NOMBRE DE CANAL VALE: ", canal)
	#print("NOMBRE DE tag VALE: ", tag_valor)
	#if Global.diccionario_global.has(nombre_usuario):
		#print("Este usuario ya se unio : ", nombre_usuario)
		#$AudioErrorYaUnido.play() #debug
		#return
	#else:
		##si no esta en el diccionario, lo agregamos al juego
		#if tag_moderador == "1": #si es moderador
			#es_moderador = true
			#print("ENTRE ACAAAA ES MODERADORRRRRRRRRRRRRRRRRRRRR -----------")
		#$"..".spawnear_godotito(nombre_usuario,color ,es_moderador) #el nombre se setea en main y se guarda en el diccionario
		#$AudioJoin.play()


#func mensaje(cmd_info : CommandInfo, args : PackedStringArray):
##	$AudioSonido.play() #solo debug
	#var mensaje_del_usuario : String = " ".join(args)
	#var nombre_usuario : String= cmd_info.sender_data.user
	#print("EL USUARIO ES : ", nombre_usuario)
	#print("El mensaje que mando es: ", mensaje_del_usuario)
	#if esta_en_el_diccionario(nombre_usuario):
		#$"..".mostrar_mensaje(nombre_usuario, mensaje_del_usuario)
	#else:
		#print("El usuario %s intenta usar la funcion pero no esta en la partida" %nombre_usuario)



#----------#########------------FIN COMANDOS DEL CHAT --------------##########--------------

func _on_button_conectar_con_twitch_pressed() -> void:
#	$CanvasLayer.hide() #temporal
	var auth : ImplicitGrantFlow = ImplicitGrantFlow.new()
	get_tree().process_frame.connect(auth.poll) 

	var token : UserAccessToken = await(auth.login(client_id, ["chat:read", "chat:edit"])) #aca estan los scopes
	print("TOKEN VALE: ", token)
	if (token == null):
		# Authentication failed. Abort.
		return

	id = TwitchIDConnection.new(token)
	irc = TwitchIRCConnection.new(id)
	api = TwitchAPIConnection.new(id)
	iconloader = TwitchIconDownloader.new(api)
	var user_info = await id.get_user_info(self) #funcion que agregue
	if user_info != {}:
		print("User ID vale... ", user_info["id"])
		username = user_info["login"]
		channel = user_info["login"]
		print("Login del usuario: ", username)

	get_tree().process_frame.connect(id.poll)

	# Connect to the Twitch chat.
	if(!await(irc.connect_to_irc(username))):
		# Authentication failed. Abort.
		conexion_fallida_mostrar_botones()
		return
	else:
		conexion_exitosa_esconder_botones()
	irc.request_capabilities()
	# Join the channel specified in the exported 'channel' variable.
	irc.join_channel(channel)

	# #####   Agregar comandos, pueden ser personalizados como el de sonido  #####
	cmd_handler.add_command("helloworld", hello)
	cmd_handler.add_command("probando", probando)
	cmd_handler.add_alias("helloworld", "hello")
	cmd_handler.add_command("list", list, -1, 1)
#	cmd_handler.add_command("join", join)
	cmd_handler.add_alias("join", "unirse")
	cmd_handler.add_alias("poop", "caca")

	#cmd_handler.add_command("follow", seguir_a_jugador, -1, 1) #-1 sin limite de argumentos, 1 limite minimo de argumentos
	cmd_handler.add_alias("follow", "seguir")
#	Global.set_nombre_streamer_global(username) #seteo el nombre del streamer para usar en cualquier otro script
#	print("Username del streamer se guardo en global")
	# For the chat example to work, we forward the messages received to the put_chat function.
	irc.chat_message.connect(put_chat)

	# We also have to forward the messages to the command handler to handle them.
	irc.chat_message.connect(cmd_handler.handle_command)
	# If you also want to accept whispers, connect the signal and bind true as the last arg.
	irc.whisper_message.connect(cmd_handler.handle_command.bind(true))

	# When we press enter on the chat bar or press the send button, we want to execute the send_message
	# function.
	%LineEdit.text_submitted.connect(send_message.unbind(1))
	%Button.pressed.connect(send_message)
	print("**** Conectado correctamente al canal ", channel)
	# This part of the example only works if GIFT is logged in to your broadcaster account.
	# If you are, you can uncomment this to also try receiving follow events.
	# Don't forget to also add the 'moderator:read:followers' scope to your token.
#	eventsub = TwitchEventSubConnection.new(api)
#	await(eventsub.connect_to_eventsub())
#	eventsub.event.connect(on_event)
#	var user_ids : Dictionary = await(api.get_users_by_name([username]))
#	if (user_ids.has("data") && user_ids["data"].size() > 0):
#		var user_id : String = user_ids["data"][0]["id"]
#		eventsub.subscribe_event("channel.follow", "2", {"broadcaster_user_id": user_id, "moderator_user_id": user_id})
