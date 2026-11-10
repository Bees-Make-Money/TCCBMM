// Troca o background pela versão queimada (se você tiver a arte) quando o hotel pega fogo
if (scr_flag("hotel_burned") && !applied && burned_bg != -1) {
    var _layer = layer_get_id(bg_layer_name);
    if (_layer != -1) layer_background_sprite(layer_background_get_id(_layer), burned_bg);
    applied = true;
}