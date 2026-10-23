function scr_get_bucket_sprite(_full) {
    if (!variable_global_exists("bucket_sprites")) global.bucket_sprites = [-1, -1];

    var _idx = _full ? 1 : 0;
    if (global.bucket_sprites[_idx] != -1 && sprite_exists(global.bucket_sprites[_idx])) {
        return global.bucket_sprites[_idx];
    }

    var _surf = surface_create(48, 48);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);

    // alça
    draw_set_color(make_color_rgb(90, 92, 100));
    draw_line_width(11, 18, 16, 8, 3);
    draw_line_width(16, 8, 32, 8, 3);
    draw_line_width(32, 8, 37, 18, 3);

    // corpo de aço
    draw_set_color(make_color_rgb(150, 156, 168));
    draw_triangle(10, 18, 38, 18, 34, 43, false);
    draw_triangle(10, 18, 34, 43, 14, 43, false);

    // faixas
    draw_set_color(make_color_rgb(110, 116, 128));
    draw_line_width(11, 26, 37, 26, 2);
    draw_line_width(12, 34, 36, 34, 2);

    // boca do balde
    draw_set_color(make_color_rgb(190, 196, 208));
    draw_ellipse(9, 13, 39, 23, false);

    // interior: água ou vazio
    if (_full) {
        draw_set_color(make_color_rgb(70, 140, 235));
    }
    else {
        draw_set_color(make_color_rgb(30, 30, 38));
    }
    draw_ellipse(12, 15, 36, 22, false);
    if (_full) {
        draw_set_color(make_color_rgb(190, 225, 255));
        draw_line_width(17, 18, 25, 18, 1);
    }

    draw_set_color(c_white);
    surface_reset_target();

    var _spr = sprite_create_from_surface(_surf, 0, 0, 48, 48, false, false, 24, 24);
    surface_free(_surf);

    global.bucket_sprites[_idx] = _spr;
    return _spr;
}

/// Deixa o item (pelo nome) selecionado no inventário, como se o jogador
/// tivesse clicado em "Selecionar". Devolve true se achou o item.
function scr_select_inventory_item(_name) {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        var _it = global.inventory_items[i];
        if (_it != noone && _it.name == _name) {
            global.selected_item = _name;
            global.selected_inventory_slot = i;
            return true;
        }
    }
    return false;
}

/// Troca um item do inventário por outro, NO MESMO SLOT (ex.: Balde -> Balde
/// com Água). Se _select for true, o novo item já fica selecionado.
function scr_swap_inventory_item(_old_name, _new_sprite, _new_name, _select = true) {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        var _it = global.inventory_items[i];
        if (_it != noone && _it.name == _old_name) {
            global.inventory_items[i] = { sprite: _new_sprite, name: _new_name };
            if (_select) {
                global.selected_item = _new_name;
                global.selected_inventory_slot = i;
            }
            return i;
        }
    }
    return -1;
}

/// Sprite do "Papel Chamuscado" com a ordem (4 numerais romanos em 2x2).
function scr_make_order_paper_sprite(_labels) {
    var _surf = surface_create(48, 48);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);

    // papel
    draw_set_color(make_color_rgb(222, 205, 160));
    draw_rectangle(8, 4, 40, 44, false);

    // cantos queimados
    draw_set_color(make_color_rgb(40, 22, 10));
    draw_triangle(8, 4, 18, 4, 8, 14, false);
    draw_triangle(40, 44, 30, 44, 40, 34, false);
    draw_triangle(40, 4, 33, 4, 40, 10, false);
    draw_set_color(make_color_rgb(230, 110, 30));
    draw_line_width(8, 14, 18, 4, 1);
    draw_line_width(40, 34, 30, 44, 1);
    draw_set_color(make_color_rgb(120, 90, 50));
    draw_rectangle(8, 4, 40, 44, true);

    // a ordem, em 2 linhas de 2 numerais
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(70, 20, 15));
    var _px = [17, 31, 17, 31];
    var _py = [17, 17, 32, 32];
    for (var i = 0; i < 4; i++) {
        // se os numerais ficarem grandes/pequenos demais na sua fonte, ajuste 0.5
        draw_text_transformed(_px[i], _py[i], _labels[i], 0.5, 0.5, 0);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    surface_reset_target();

    var _spr = sprite_create_from_surface(_surf, 0, 0, 48, 48, false, false, 24, 24);
    surface_free(_surf);
    return _spr;
}
