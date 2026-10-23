
function scr_point_seg_dist(_px, _py, _x1, _y1, _x2, _y2) {
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    var _len2 = _dx * _dx + _dy * _dy;
    if (_len2 == 0) return point_distance(_px, _py, _x1, _y1);
    var _t = clamp(((_px - _x1) * _dx + (_py - _y1) * _dy) / _len2, 0, 1);
    return point_distance(_px, _py, _x1 + _t * _dx, _y1 + _t * _dy);
}

function scr_draw_gear(_sprite_name, _x, _y, _diameter, _angle = 0, _blend = c_white, _alpha = 1) {
    if (asset_get_type(_sprite_name) == asset_sprite) {
        var _spr   = asset_get_index(_sprite_name);
        var _w     = sprite_get_width(_spr);
        var _h     = sprite_get_height(_spr);
        var _scale = _diameter / max(_w, _h);

        // deslocamento do centro da imagem em relação à origem do sprite
        var _dx = (_w / 2 - sprite_get_xoffset(_spr)) * _scale;
        var _dy = (_h / 2 - sprite_get_yoffset(_spr)) * _scale;

        // gira esse deslocamento junto com o sprite (gira em torno do centro)
        var _rx =  _dx * dcos(_angle) + _dy * dsin(_angle);
        var _ry = -_dx * dsin(_angle) + _dy * dcos(_angle);

        draw_sprite_ext(_spr, 0, _x - _rx, _y - _ry, _scale, _scale, _angle, _blend, _alpha);
    }
    else {
        var _r = _diameter / 2;
        var _col = (_blend == c_white) ? make_color_rgb(190, 150, 60) : _blend;
        var _teeth = max(8, floor(_r / 3));

        draw_set_alpha(_alpha);
        draw_set_color(_col);
        for (var i = 0; i < _teeth; i++) {
            var _a = _angle + i * (360 / _teeth);
            draw_line_width(_x + lengthdir_x(_r * 0.75, _a), _y + lengthdir_y(_r * 0.75, _a),
                            _x + lengthdir_x(_r, _a),        _y + lengthdir_y(_r, _a),
                            max(2, _r * 0.16));
        }
        draw_circle(_x, _y, _r * 0.82, false);
        draw_set_color(make_color_rgb(20, 14, 6));
        draw_circle(_x, _y, _r * 0.28, false);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

/// Sorteia (uma única vez por partida) a posição dos 4 itens do puzzle e
/// devolve a posição do item pedido. Assim, se o jogador sair da sala e
/// voltar, os itens que sobraram continuam no mesmo lugar.
function scr_get_pickup_spawn(_key) {
    if (!variable_global_exists("pickup_spawns")) {
        global.pickup_spawns = {};

        // ----------- ajuste aqui se precisar -----------
        // área onde os itens podem aparecer (x1, y1, x2, y2), dentro de 816x624
        var _area = [48, 48, 768, 576];

        // zonas proibidas (x1, y1, x2, y2)
        var _block = [
            [176, 56, 640, 376],   // painel (432x288 em x=192, y=72, com folga)
            [96, 480, 400, 624]    // botões da interface (y ~ 528)
        ];

        // distância mínima entre dois itens
        var _min_dist = 110;
        // -----------------------------------------------

        var _keys     = ["gear_large", "gear_medium", "gear_small", "pliers"];
        var _fallback = [[120, 420], [330, 430], [560, 430], [700, 540]];
        var _placed   = [];

        for (var k = 0; k < array_length(_keys); k++) {
            // se o sorteio falhar 500 vezes, usa a posição reserva
            var _px = _fallback[k][0];
            var _py = _fallback[k][1];

            repeat (500) {
                var _tx = irandom_range(_area[0], _area[2]);
                var _ty = irandom_range(_area[1], _area[3]);
                var _ok = true;

                for (var b = 0; b < array_length(_block); b++) {
                    if (point_in_rectangle(_tx, _ty, _block[b][0], _block[b][1], _block[b][2], _block[b][3])) {
                        _ok = false;
                        break;
                    }
                }

                if (_ok) {
                    for (var p = 0; p < array_length(_placed); p++) {
                        if (point_distance(_tx, _ty, _placed[p][0], _placed[p][1]) < _min_dist) {
                            _ok = false;
                            break;
                        }
                    }
                }

                if (_ok) {
                    _px = _tx;
                    _py = _ty;
                    break;
                }
            }

            array_push(_placed, [_px, _py]);
            variable_struct_set(global.pickup_spawns, _keys[k], { x: _px, y: _py });
        }
    }

    return global.pickup_spawns[$ _key];
}

/// Move a instância que chamou para a posição sorteada da chave dada e
/// garante que o sprite inteiro fique dentro da room.
function scr_place_pickup(_key) {
    var _spawn = scr_get_pickup_spawn(_key);
    x = _spawn.x;
    y = _spawn.y;

    if (bbox_left   < 8)                 x += 8 - bbox_left;
    if (bbox_right  > room_width - 8)    x -= bbox_right - (room_width - 8);
    if (bbox_top    < 8)                 y += 8 - bbox_top;
    if (bbox_bottom > room_height - 8)   y -= bbox_bottom - (room_height - 8);
}


