draw_stadium();
draw_goal_net();
draw_keeper_figure();
draw_player_figure();
draw_ball_at(ball_x, ball_y, ball_r);
draw_goal_posts();
draw_aim();
draw_hud();
// tela da morte: só a mensagem, em vermelho
if (st == "death_msg" || (st == "dead" && death_a > 0)) {
    draw_set_alpha(death_a);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_red);
    // quebra a linha sozinho para caber na tela; ajuste o 2.2 se ficar grande/pequeno
    draw_text_ext_transformed(room_width / 2, room_height / 2, string_copy(death_message, 1, floor(death_idx)),
                              -1, (room_width - 80) / 2.2, 2.2, 2.2, 0);
}


draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
