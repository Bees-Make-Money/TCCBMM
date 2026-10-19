// registra se a interface estava travada no passo anterior (usado no clique)
was_locked = global.interaction_locked;

// o jogador não pode sair da memória: remove o botão de trocar de sala e a lanterna
// (o botão do inventário continua)
if (instance_exists(obj_room_change_button)) instance_destroy(obj_room_change_button);
if (instance_exists(obj_flashlight))         instance_destroy(obj_flashlight);

// espera um diálogo da cutscene terminar
if (wait_dialog) {
    if (instance_exists(obj_dialog_box)) exit;
    wait_dialog = false;
}

// qualquer outra trava (inventário aberto, fade...) congela a cena
// Só bloqueia a cena se estivermos propriamente a jogar e houver uma trava ativa
if (st == "play" && global.interaction_locked) exit;

anim_t++;

// ---------- atualizações gerais ----------
if (caption_t > 0) caption_t--;
if (reflect_t > 0) reflect_t--;

dark_a = lerp(dark_a, lights_on ? 0 : 0.55, 0.04);

light_flick = false;
if (flicker_t > 0) {
    flicker_t--;
    light_flick = ((anim_t mod 10) < 5);
}

for (var q = 0; q < array_length(zones); q++) {
    if (zones[q].splash > 0) zones[q].splash--;
    if (zones[q].steam > 0)  zones[q].steam--;
}

// ---------- máquina de estados ----------
switch (st) {

    // cartela "SALÃO DE EVENTOS - 18/09/1993 - 23:44"
    case "title":
        t++;
        black_a = 1;
        if (t >= (retry ? 80 : 190)) {
            st = "intro_a";
            t = 0;
        }
    break;

    // abre o preto e mostra o salão ainda inteiro
    case "intro_a":
        t++;
        black_a = max(0, black_a - 0.02);
        if (black_a <= 0 && t > 60) {
            if (!retry) {
                scr_show_dialog(lines_intro_a, "Detetive", c_white);
                wait_dialog = true;
            }
            st = "intro_fire";
            t = 0;
            fs = 0;
        }
    break;

    // a silhueta acende o primeiro foco e a porta é trancada
    case "intro_fire":
        t++;
        switch (fs) {

            case 0:   // luzes piscam e o vulto aparece
                flicker_t = 30;
                sil_x = zones[ignite_order[0]].x;
                sil_start_x = sil_x;
                sil_a = min(1, t / 40);
                if (t >= 70) { fs = 1; t = 0; }
            break;

            case 1:   // fósforo e primeiro foco
                sil_a = 1;
                sil_flare = clamp(t / 30, 0, 1);
                if (t == 45) ignite_zone(ignite_order[0]);
                if (t >= 100) {
                    sil_flare = 0;
                    if (!retry) {
                        scr_show_dialog(lines_intro_b, "Detetive", c_white);
                        wait_dialog = true;
                    }
                    fs = 2;
                    t = 0;
                }
            break;

            case 2:   // o vulto caminha até a porta e some
                sil_x = lerp(sil_start_x, door_x, clamp(t / 110, 0, 1));
                sil_a = 1 - clamp((t - 80) / 30, 0, 1);
                if (t >= 115) { sil_a = 0; fs = 3; t = 0; }
            break;

            case 3:   // duas voltas de chave, do lado de fora
                if (t == 25) show_caption("*clique*");
                if (t == 60) show_caption("*clique*");
                if (t >= 100) {
                    if (!retry) {
                        scr_show_dialog(lines_intro_c, "Detetive", c_white);
                        wait_dialog = true;
                    }
                    fs = 4;
                    t = 0;
                }
            break;

            case 4:   // começa a fase
                st = "play";
                play_t = 0;
                ignite_timer = 0;
                show_caption("Preciso de um balde... e há água no chafariz.");
            break;
        }
    break;

    // a fase em si
    case "play":
        play_t++;

        // ignições programadas
        ignite_timer++;
        if (ignited < 4 && ignite_timer >= ignite_gap) {
            ignite_zone(ignite_order[ignited]);
            ignite_timer = 0;
        }

        // o fogo cresce (mais devagar no começo)
        var _speed   = (play_t < grace_frames) ? 0.5 : 1;
        var _all_out = (ignited >= 4);
        for (var i = 0; i < array_length(zones); i++) {
            var _z = zones[i];
            if (_z.state == "burning") {
                var _rate = variable_struct_get(fabrics, _z.type).rate;
                _z.inten = min(1, _z.inten + _rate * _speed);
                if (_z.inten >= 1) {
                    st = "fail";
                    t = 0;
                }
            }
            if (_z.state != "out") _all_out = false;
        }

        // vozes abafadas
        for (var v = 0; v < array_length(voices); v++) {
            if (play_t == voices[v].t) show_caption(voices[v].txt);
        }

        // vitória: todas acenderam e todas apagaram
        if (st == "play" && _all_out) {
            st = "win";
            t = 0;
            ws = 0;
        }
    break;

    // o salão se perde: a memória recomeça (sem morte)
    case "fail":
        t++;
        shake = (t < 90) ? 5 : 0;
        fail_flash = min(1, t / 40);
        if (t == 1) show_caption("As chamas tomaram o salão!");
        if (t > 100) black_a = min(1, black_a + 0.02);
        if (t >= 240) {
            global.fire_retry = true;
            scr_remove_item_from_inventory("Balde");
            scr_remove_item_from_inventory("Balde com Água");
            scr_flag_set("bucket_taken", false);
            global.selected_item = "";
            global.selected_inventory_slot = noone;

            var _fr = instance_create_depth(0, 0, -9998, obj_fade);
            _fr.target_room = rm_incendio;
            st = "dead";
        }
    break;

    // final: a ordem é revelada
    case "win":
        t++;
        switch (ws) {

            case 0:   // silêncio, depois a primeira fala
                if (t >= 90) {
                    scr_show_dialog(lines_win_a, "Detetive", c_white);
                    wait_dialog = true;
                    ws = 1;
                    t = 0;
                }
            break;

            case 1:   // as placas brilham NA ORDEM do fogo
                hl_zone = ignite_order[min(3, floor(t / 70))];
                if (t >= 70 * 4) {
                    hl_zone = -1;
                    var _lb = [];
                    for (var b = 0; b < array_length(lines_win_b); b++) array_push(_lb, lines_win_b[b]);
                    array_push(_lb, "Anotei a ordem: " + order_text + ".");
                    scr_show_dialog(_lb, "Detetive", c_white);
                    wait_dialog = true;
                    ws = 2;
                    t = 0;
                }
            break;

            case 2:   // entrega o papel (o balde some, então sempre há espaço)
                scr_remove_item_from_inventory("Balde");
                scr_remove_item_from_inventory("Balde com Água");
                global.selected_item = "";
                global.selected_inventory_slot = noone;
                scr_add_item_to_inventory(scr_make_order_paper_sprite(order_labels), "Papel Chamuscado");
                scr_flag_set("fire_solved");
                scr_flag_set("order_paper_taken");
                show_caption("Papel Chamuscado guardado no inventário.");
                ws = 3;
                t = 0;
            break;

            case 3:   // o reflexo no chafariz
                if (t == 60) reflect_t = 200;
                if (t == 140) {
                    scr_show_dialog(lines_win_c, "Detetive", c_white);
                    wait_dialog = true;
                    ws = 4;
                    t = 0;
                }
            break;

            case 4:   // escurece e volta para a sala de onde entrou
                black_a = min(1, black_a + 0.02);
                if (black_a >= 1) {
                    var _ret = variable_global_exists("fire_return_room") ? global.fire_return_room : rm_hall_entrada;
                    var _fw = instance_create_depth(0, 0, -9998, obj_fade);
                    _fw.target_room = _ret;
                    st = "dead";
                }
            break;
        }
    break;
}
