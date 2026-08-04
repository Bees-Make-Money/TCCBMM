image_xscale = 12
image_yscale = 8

avaiable_rooms = scr_get_avaiable_rooms()
option_buttons = []

var start_y = 100
var spacing = 40

for(var i = 0; i < array_length(avaiable_rooms); i++){
	var data = avaiable_rooms[i]
	var btn = instance_create_layer(room_width/2, start_y + (i * spacing), "Menu", obj_room_option_button)
	btn.target_room = data.target
	btn.room_label = data.label
	array_push(option_buttons, btn)
}

