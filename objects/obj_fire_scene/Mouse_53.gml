if (st != "play") exit;
if (global.interaction_locked || was_locked) exit;

var _mx = mouse_x;
var _my = mouse_y;

// onde o jogador clicou: chafariz ou alguma cortina?
var _on_fountain = point_in_rectangle(_mx, _my, fountain_x - 90, fountain_y - 150, fountain_x + 90, fountain_y + 30);
var _zone = -1;
for (var i = 0; i < array_length(zones); i++) {
    if (point_in_rectangle(_mx, _my, zones[i].x - 52, zone_top - 14, zones[i].x + 52, zone_bottom + 16)) {
        _zone = i;
    }
}
if (!_on_fountain && _zone == -1) exit;

var _sel = global.selected_item;

// ---------- balde vazio ----------
if (_sel == "Balde") {
    if (_on_fountain) {
        scr_swap_inventory_item("Balde", bucket_full_sprite, "Balde com Água", true);
        show_caption("Enchi o balde.");
    }
    else {
        show_caption("O balde está vazio. Preciso enchê-lo no chafariz.");
    }
}
// ---------- balde cheio ----------
else if (_sel == "Balde com Água") {
    if (_zone != -1) {
        var _z = zones[_zone];

        if (_z.state == "burning") {
            _z.splash = 30;
            _z.hits++;

            var _need = variable_struct_get(fabrics, _z.type).hits;
            if (_z.hits >= _need) {
                _z.state = "out";
                _z.inten = 0;
                _z.steam = 150;
                show_caption("Apagou.");
            }
            else {
                _z.inten = max(0.1, _z.inten - 0.45);
                show_caption("O tecido é grosso... preciso de mais água.");
            }

            // o balde esvazia e já fica selecionado para encher de novo
            scr_swap_inventory_item("Balde com Água", bucket_empty_sprite, "Balde", true);
        }
        else if (_z.state == "out") {
            show_caption("Este já está apagado.");
        }
        else {
            show_caption("Ainda não pegou fogo. Melhor guardar a água.");
        }
    }
    else {
        show_caption("O balde já está cheio.");
    }
}
// ---------- sem balde selecionado ----------
else {
    if (_on_fountain) show_caption("Um chafariz de mármore. A água ainda corre...");
    else              show_caption("Isso não vai ajudar agora. Preciso de algo para carregar água.");
}
