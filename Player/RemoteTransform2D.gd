extends RemoteTransform2D
#Nodo creado para conectar la camara con el jugador, la camara seguira la posición 
#del remoteTransorm2D


func _ready():
	top_level = true
	global_position.y = 220


func _process(delta):
	global_position.x = get_parent().global_position.x
