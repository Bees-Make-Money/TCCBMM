function scr_play_sfx(_name) {
    if (asset_get_type(_name) == asset_sound) {
        audio_play_sound(asset_get_index(_name), 1, false);
    }
}

/// Mede a área iluminada do sprite da lanterna normal.
/// Devolve { r: raio em pixels, cdx/cdy: deslocamento do centro da luz em relação
/// ao ponto onde a lanterna desenha o sprite }.
function scr_ghost_measure_light(_spr) {
    var _w  = sprite_get_width(_spr);
    var _h  = sprite_get_height(_spr);
    var _ox = sprite_get_xoffset(_spr);
    var _oy = sprite_get_yoffset(_spr);

    var _cx = _w / 2;
    var _cy = _h / 2;

    var _surf = surface_create(_w, _h);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);
    gpu_set_blendenable(false);   // copia os pixels sem misturar (preserva o alpha real)
    draw_sprite(_spr, 0, _ox, _oy);
    gpu_set_blendenable(true);
    surface_reset_target();

    // alpha no centro: luz brilhante (alto) ou máscara com buraco (baixo)?
    var _a0   = ((surface_getpixel_ext(_surf, floor(_cx), floor(_cy)) >> 24) & 255) / 255;
    var _glow = (_a0 >= 0.5);

    var _r = _w / 2;
    for (var d = 0; d < _w / 2 - 1; d += 4) {
        var _a = ((surface_getpixel_ext(_surf, floor(_cx + d), floor(_cy)) >> 24) & 255) / 255;
        if (_glow && _a < 0.15)   { _r = d; break; }
        if (!_glow && _a > 0.85)  { _r = d; break; }
    }

    surface_free(_surf);
    return { r: max(_r, 16), cdx: _cx - _ox, cdy: _cy - _oy };
}
