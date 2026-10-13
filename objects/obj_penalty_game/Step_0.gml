// remove a interface padrão da room (o Room Start do game manager a cria
// depois do Create): sem botões de sala/inventário nem lanterna aqui
if (instance_exists(obj_room_change_button)) instance_destroy(obj_room_change_button);
if (instance_exists(obj_inventory_button))   instance_destroy(obj_inventory_button);
if (instance_exists(obj_flashlight))         instance_destroy(obj_flashlight);

// fades, diálogos e a tela de morte travam a interação: espera
if (global.interaction_locked) exit;

anim_t++;

// goleiro "respirando" enquanto espera
if (st != "shoot" && st != "result") {
    keeper_x = goal_cx;
    keeper_y = gy2;
    keeper_angle = 0;
    keeper_arm = 0.25 + 0.12 * sin(anim_t * 0.12);
}

switch (st) {

    case "intro":
        if (mouse_check_button_pressed(mb_left)) start_attempt();
    break;

    case "aim_x":
        aim_t += aim_speed_x;
        aim_x = goal_cx + sin(aim_t) * ((gx2 - gx1) / 2 + 40);
        aim_y = (gy1 + gy2) / 2;
        if (mouse_check_button_pressed(mb_left)) {
            lock_x = aim_x;
            aim_t = random(2 * pi);
            st = "aim_y";
        }
    break;

    case "aim_y":
        aim_t += aim_speed_y;
        aim_x = lock_x;
        aim_y = lerp(gy1 - 34, gy2 - 4, (sin(aim_t) + 1) / 2);
        if (mouse_check_button_pressed(mb_left)) fire();
    break;

    case "shoot":
        shot_t++;
        var _e = clamp(shot_t / shot_frames, 0, 1);

        // bola
        ball_x = lerp(spot_x, shot_tx, _e);
        ball_y = lerp(spot_y, shot_ty, _e) - sin(pi * _e) * 24;
        ball_r = lerp(9, 6, _e);
        kick_t = min(1, shot_t / 8);

        // goleiro mergulha (um pouco mais rápido que a bola)
        keeper_e = min(1, _e * 1.6);
        keeper_angle = -keeper_side * 75 * keeper_e;
        keeper_arm   = keeper_e;
        keeper_x = lerp(goal_cx, keeper_hand_x - keeper_side * 35, keeper_e);
        keeper_y = lerp(gy2, min(gy2, keeper_hand_y + 55), keeper_e);
        if (keeper_side == 0) keeper_y -= sin(pi * keeper_e) * 10;

        if (shot_t >= shot_frames) finish_shot();
    break;

    case "result":
        result_timer--;
        if (result_timer <= 0) {
            if (goals >= goals_needed) {
                st = "win";
                win_stage = 0;
            }
            else if (misses >= max_misses) {
                st = "lose";
                end_timer = 40;
            }
            else {
                start_attempt();
            }
        }
    break;

    case "win":
        if (win_stage == 0) {
            scr_flag_set("penalty_won");
            scr_flag_set("paper_digit_taken");

            // papel com o dígito misterioso (precisa de 1 slot livre no inventário)
            var _paper = scr_make_paper_sprite(mystery_digit);
            scr_add_item_to_inventory(_paper, "Papel Misterioso");

            scr_show_dialog(["Os portões se abriram... eu estou livre!",
                             "No bolso da camisa havia um papel com um número escrito: " + string(mystery_digit) + "."],
                            "Detetive", c_white);
            win_stage = 1;
        }
        else if (win_stage == 1) {
            // só chega aqui depois que o diálogo foi fechado
            var _f = instance_create_depth(0, 0, -9998, obj_fade);
            _f.target_room = rm_sala_negocios_3;
            win_stage = 2;
        }
    break;

    case "lose":
        end_timer--;
        if (end_timer <= 0) {
            var _d = instance_create_depth(0, 0, -9999, obj_death);
            _d.texto = "O homem que morreu em pé";
            st = "dead";
        }
    break;
}
