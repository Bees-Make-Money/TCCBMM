has_save = file_exists(SAVE_FILE);
hover = has_save && !instance_exists(obj_fade) && point_in_rectangle(mouse_x, mouse_y, x, y, x + btn_w, y + btn_h);

if (hover && mouse_check_button_pressed(mb_left)) {
    window_set_cursor(cr_default);
    scr_load_game();
}

// com jogo salvo, troca de lugar com o botão "Novo jogo" (uma vez só)
if (!swapped) {
    swapped = true;
    if (has_save) {
        var _idx = asset_get_index(newgame_obj_name);
        if (_idx != -1 && asset_get_type(newgame_obj_name) == asset_object && instance_exists(_idx)) {
            var _ng  = instance_find(_idx, 0);
            var _ngx = (_ng.sprite_index != -1) ? (_ng.bbox_left + _ng.bbox_right) / 2 : _ng.x;
            var _ngy = (_ng.sprite_index != -1) ? (_ng.bbox_top + _ng.bbox_bottom) / 2 : _ng.y;
            var _myx = x + btn_w / 2;
            var _myy = y + btn_h / 2;

            // o CONTINUAR vai para o lugar do Novo jogo...
            x = _ngx - btn_w / 2;
            y = _ngy - btn_h / 2;
            // ...e o Novo jogo vai para o lugar do CONTINUAR
            _ng.x += (_myx - _ngx);
            _ng.y += (_myy - _ngy);
        }
    }
}

// desativado: sem save, nada responde
hover = has_save && !instance_exists(obj_fade) && point_in_rectangle(mouse_x, mouse_y, x, y, x + btn_w, y + btn_h);

if (hover && mouse_check_button_pressed(mb_left)) {
    window_set_cursor(cr_default);
    scr_load_game();
}

// só mexe no cursor quando muda (não briga com o cursor do Novo jogo)
if (hover != prev_hover) {
    window_set_cursor(hover ? cr_handpoint : cr_default);
    prev_hover = hover;
}