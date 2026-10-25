// o jogador não pode sair da sala: tira o botão de trocar de sala da tela.
// NÃO destrua o botão: a lanterna lê obj_room_change_button.can_click a cada
// frame e dá erro se ele não existir. Então ele só vai para fora da room.
with (obj_room_change_button) {
    x = -2000;
    y = -2000;
    visible = false;
}

// espera um diálogo da cutscene terminar
if (wait_dialog) {
    if (instance_exists(obj_dialog_box)) exit;
    wait_dialog = false;
}

// qualquer outra trava (fade...) congela a cena
if (global.interaction_locked) exit;

anim_t++;
if (caption_t > 0)  caption_t--;
if (flash_t > 0)    flash_t--;
if (scare_t > 0)    scare_t--;
if (static_t > 0)   static_t--;
if (blackout_t > 0) blackout_t--;
heart_pulse *= 0.88;

// fim do apagão: a lanterna volta
if (bo_restore && blackout_t <= 0) {
    bo_restore = false;
    if (instance_exists(obj_flashlight)) obj_flashlight.active = true;
}

// ---------- luz da lanterna normal ----------
fl_on = false;
if (instance_exists(obj_flashlight) && obj_flashlight.active) {
    fl_on = true;
    lx = obj_flashlight.light_x + light_cdx;
    ly = obj_flashlight.light_y + light_cdy;
}

// ---------- máquina de estados ----------
switch (st) {

    // abre o preto e conta onde o detetive está
    case "fade_in":
        black_a = max(0, black_a - 0.02);
        if (black_a <= 0) {
            if (!retry) {
                scr_show_dialog(lines_intro, "Detetive", c_white);
                wait_dialog = true;
            }
            st = "play";
            play_t = 0;
        }
    break;

    // a caçada
    case "play":
        // na primeira vez, liga a lanterna sozinho
        if (!play_started) {
            play_started = true;
            if (instance_exists(obj_flashlight)) obj_flashlight.active = true;
            show_caption("Segure a luz sobre eles!");
        }

        // durante um susto de ambiente, a caçada fica congelada
        if (scare_t > 0) break;

        play_t++;

        // susto de ambiente
        for (var s = 0; s < array_length(scare_times); s++) {
            if (play_t == scare_times[s]) trigger_scare(48, false);
        }

        // apagão total (estilo FNAF): a luz some e todos dão um salto
        if (play_t >= next_blackout && blackout_t <= 0) {
            blackout_t = blackout_len;
            next_blackout = play_t + irandom_range(blackout_min, blackout_max);
            bo_restore = (instance_exists(obj_flashlight) && obj_flashlight.active);
            if (bo_restore) obj_flashlight.active = false;
            fl_on = false;
            static_t = blackout_len;
            scr_play_sfx("snd_static");
            for (var b = 0; b < array_length(ghosts); b++) {
                if (ghosts[b].state == "active") ghost_jump(ghosts[b], 1.5);
            }
        }

        // ativa o próximo fantasma
        if (play_t >= first_spawn && ((play_t - first_spawn) mod spawn_gap) == 0) {
            var _k = (play_t - first_spawn) div spawn_gap;
            if (_k < ghost_count) {
                var _ng = ghosts[spawn_order[_k]];
                _ng.state = "active";
                _ng.glitch = 20;
                _ng.jt = irandom_range(jump_min, jump_max);
                static_t = max(static_t, 10);
                scr_play_sfx("snd_ghost_whisper");
            }
        }

        var _left = 0;
        var _aggr = 1 + banished * ramp_per_banish;
        min_dist = 9999;

        for (var i = 0; i < array_length(ghosts); i++) {
            var _g = ghosts[i];
            if (_g.state == "gone") continue;
            _left++;

            // fantasma sumindo depois de banido
            if (_g.state == "banish") {
                _g.fade -= 0.025;
                _g.y -= 0.8;
                if (_g.fade <= 0) _g.state = "gone";
                continue;
            }
            if (_g.state != "active") continue;

            if (_g.glitch > 0) _g.glitch--;

            var _dist = point_distance(_g.x, _g.y, cx, cy);
            min_dist = min(min_dist, _dist);
            _g.scale = lerp(0.7, 1.5, 1 - clamp(_dist / _g.dist0, 0, 1));

            // a luz está em cima dele?
            var _d = point_distance(_g.x, _g.y - 65 * _g.scale, lx, ly);
            _g.vis = fl_on ? clamp(1.3 - _d / light_r, 0, 1) : 0;
            _g.lit = (fl_on && _g.vis > 0.35);

            if (_g.lit) {
                // preso pela luz: para, treme e o anel se enche
                _g.charge += 1 / charge_frames;
                if (irandom(2) == 0) _g.glitch = max(_g.glitch, 3);
                if (_g.charge >= 1) {
                    _g.state = "banish";
                    _g.fade = 1;
                    banished++;
                    flash_x = _g.x;
                    flash_y = _g.y - 65 * _g.scale;
                    flash_t = 24;
                    static_t = max(static_t, 6);
                    show_caption(whispers[_g.style mod array_length(whispers)]);
                    scr_play_sfx("snd_ghost_banish");
                }
            }
            else {
                // no escuro ele avança, acelera perto do detetive e dá pulos
                _g.charge = max(0, _g.charge - 1 / (charge_frames * 2));
                var _spd = _g.spd * _aggr * ((_dist < rush_dist) ? rush_mult : 1);
                var _dir = point_direction(_g.x, _g.y, cx, cy);
                _g.x += lengthdir_x(_spd, _dir);
                _g.y += lengthdir_y(_spd, _dir);

                _g.jt--;
                if (_g.jt <= 0) {
                    ghost_jump(_g, 1);
                    _g.jt = irandom_range(jump_min, jump_max);
                }
            }

            // chegou no detetive: JUMPSCARE
            if (_dist <= catch_radius && _g.state == "active") {
                trigger_scare(130, true);
                st = "fail";
                t = 0;
                break;
            }
        }

        // batimento cardíaco: mais rápido quanto mais perto o perigo
        if (st == "play" && min_dist < 9000) {
            var _period = lerp(75, 20, clamp(1 - min_dist / 260, 0, 1));
            heart_t++;
            if (heart_t >= _period) {
                heart_t = 0;
                heart_pulse = 1;
                scr_play_sfx("snd_heartbeat");
            }
        }

        // vitória: todos banidos e desfeitos
        if (st == "play" && _left == 0 && banished >= ghost_count) {
            st = "win";
            t = 0;
            ws = 0;
        }
    break;

    // o fantasma te pegou
    case "fail":
        t++;
        if (t > 120) black_a = min(1, black_a + 0.04);
        if (t >= 170) {
            if (on_fail == "death") {
                var _dth = instance_create_depth(0, 0, -9999, obj_death);
                _dth.texto = death_text;
            }
            else {
                global.ghost_retry = true;
                var _fr = instance_create_depth(0, 0, -9998, obj_fade);
                _fr.target_room = rm_fantasmas;
            }
            st = "dead";
        }
    break;

    // todos banidos
    case "win":
        t++;
        switch (ws) {

            case 0:   // silêncio, fala final e recompensa
                if (t >= 60) {
                    scr_flag_set("ghosts_solved");
                    if (instance_exists(obj_flashlight)) obj_flashlight.active = false;

                    if (reward_item != "") {
                        var _rs = (reward_sprite != -1) ? reward_sprite : scr_get_simple_placeholder("ghost_reward", 48, 48, make_color_rgb(90, 60, 120), reward_item);
                        scr_add_item_to_inventory(_rs, reward_item);
                    }

                    scr_show_dialog(lines_win, "Detetive", c_white);
                    wait_dialog = true;
                    ws = 1;
                    t = 0;
                }
            break;

            case 1:   // escurece e volta para a sala do livro
                black_a = min(1, black_a + 0.02);
                if (black_a >= 1) {
                    var _ret = variable_global_exists("ghost_return_room") ? global.ghost_return_room : rm_sala_negocios_1;
                    var _fw = instance_create_depth(0, 0, -9998, obj_fade);
                    _fw.target_room = _ret;
                    st = "dead";
                }
            break;
        }
    break;
}

