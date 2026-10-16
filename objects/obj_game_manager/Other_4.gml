var _room_width = room_width;
var _room_height = room_height;

surface_resize(application_surface, _room_width, _room_height);

window_set_size(_room_width, _room_height);
scr_increment_room_visits(room)

if (scr_room_has_hud(room)) {
	if (instance_exists(obj_room_change_button)) {
		instance_destroy(obj_room_change_button);
	}
	if (instance_exists(obj_inventory_button)) {
		instance_destroy(obj_inventory_button);
	}
	if (instance_exists(obj_flashlight)) {
		instance_destroy(obj_flashlight);
	}
	instance_create_layer(144, 528, "Buttons", obj_room_change_button)
	instance_create_layer(300, 528, "Buttons", obj_inventory_button)
	instance_create_layer(0, 0, "Menu", obj_flashlight)
}
else {
	instance_destroy(obj_room_change_button);
	instance_destroy(obj_inventory_button);
	instance_destroy(obj_flashlight);
}
if (room == rm_corredor_superior && scr_flag("flask_taken")) {
    scr_flag_set("meeting_papers_cleared");
}