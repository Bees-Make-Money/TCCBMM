depth = 15000;

// Esconde layers de Background do room só durante o jogo (não altera o room)
var _layers = layer_get_all();
for (var i = 0; i < array_length(_layers); i++) {
    if (layer_background_get_id(_layers[i]) != -1) {
        layer_set_visible(_layers[i], false);
    }
}

backgrounds = [
    spr_hall_entrada,
    spr_varanda_superior,
    spr_corredor_superior_pintado,
    spr_potas_inferiores,
    spr_sala_reunioes,
    spr_sala_reunioes_escura
];

current = 0;
next = 1;

state = "showing";                              // "showing" ou "fading"
timer = 0;
display_time = 6 * game_get_speed(gamespeed_fps); // tempo parado em cada cenário (6 s)
fade_time = 1.5 * game_get_speed(gamespeed_fps);  // duração da transição (1,5 s)
fade_alpha = 0;

zoom_cur = 1;
zoom_next = 1;
zoom_speed = 0.00008; // zoom lento, dá vida ao fundo

// Desenha o sprite cobrindo a sala inteira, centralizado e com zoom
draw_cover = function(_spr, _zoom, _alpha) {
    var _w = sprite_get_width(_spr);
    var _h = sprite_get_height(_spr);
    var _scale = max(room_width / _w, room_height / _h) * _zoom;
    var _x = room_width / 2 - (_w / 2 - sprite_get_xoffset(_spr)) * _scale;
    var _y = room_height / 2 - (_h / 2 - sprite_get_yoffset(_spr)) * _scale;
    draw_sprite_ext(_spr, 0, _x, _y, _scale, _scale, 0, c_white, _alpha);
}
_layers = layer_get_all();
