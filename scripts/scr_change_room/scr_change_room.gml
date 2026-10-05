function scr_change_room(target_room) {
    if (target_room == room) return;
	
	if (target_room == rm_sala_negocios_3) {
        if (!global.flags.gear_panel_solved || !global.flags.wiring_fixed) {
            scr_show_dialog(["Preciso consertar o painel e a fiação da sala de negociações antes de seguir em frente"], "Detetive", c_white);
            return;
        }
    }
	if (room == rm_sala_negocios_3 && target_room == rm_sala_negocios_4) {
        if (!global.lens_attached) {
            scr_show_dialog(["Está escuro demais aqui, preciso enxergar melhor antes de continuar"], "Detetive", c_white);
            return;
        }
    }
	
	if (!instance_exists(obj_fade)) {
        var _fade = instance_create_depth(0, 0, -9999, obj_fade); 
        _fade.target_room = target_room;
    }
}