
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
/// Área do background da sala (onde os itens podem aparecer).
/// Se o background não começa em (0, 0), mude _bg_x e _bg_y.
function scr_pickup_bounds() {
    var _bg_x = 0;
    var _bg_y = 0;
    var _bg_w = 816;
    var _bg_h = 432;
    return { x1: _bg_x, y1: _bg_y, x2: _bg_x + _bg_w, y2: _bg_y + _bg_h };
}

/// Sorteia (uma vez por sala) a posição dos 4 itens, sempre DENTRO do background.
function scr_get_pickup_spawn(_key) {
    // recalcula quando a sala muda (cada sala tem o seu fundo)
    if (!variable_global_exists("pickup_spawns") || global.pickup_spawns_room != room) {
        global.pickup_spawns = {};
        global.pickup_spawns_room = room;

        var _b = scr_pickup_bounds();
        var _m = 44;   // margem: o item nunca encosta na borda do background

        // área sorteável (dentro do background)
        var _area = [_b.x1 + _m, _b.y1 + _m, _b.x2 - _m, _b.y2 - _m];

        // zonas proibidas (x1, y1, x2, y2). Ajuste para onde está o seu painel.
        var _block = [
            [176, 56, 640, 376]    // painel (432x288 em x=192, y=72)
        ];

        var _min_dist = 110;   // distância mínima entre dois itens

        var _keys = ["gear_large", "gear_medium", "gear_small", "pliers"];

        // posições reservas (nos cantos do background) se o sorteio falhar
        var _fallback = [
            [_b.x1 + 90, _b.y1 + 90],
            [_b.x1 + 90, _b.y2 - 90],
            [_b.x2 - 90, _b.y1 + 90],
            [_b.x2 - 90, _b.y2 - 90]
        ];
        var _placed = [];

        for (var k = 0; k < array_length(_keys); k++) {
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

/// Move a instância que chamou para a posição sorteada e garante que o
/// sprite INTEIRO fique dentro do background.
function scr_place_pickup(_key) {
    var _spawn = scr_get_pickup_spawn(_key);
    x = _spawn.x;
    y = _spawn.y;

    var _b   = scr_pickup_bounds();
    var _pad = 8;
    if (bbox_left   < _b.x1 + _pad) x += (_b.x1 + _pad) - bbox_left;
    if (bbox_right  > _b.x2 - _pad) x -= bbox_right - (_b.x2 - _pad);
    if (bbox_top    < _b.y1 + _pad) y += (_b.y1 + _pad) - bbox_top;
    if (bbox_bottom > _b.y2 - _pad) y -= bbox_bottom - (_b.y2 - _pad);
}

