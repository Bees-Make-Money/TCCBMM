has_save = file_exists(SAVE_FILE);
hover = has_save && !instance_exists(obj_fade) && point_in_rectangle(mouse_x, mouse_y, x, y, x + btn_w, y + btn_h);

if (hover && mouse_check_button_pressed(mb_left)) {
    window_set_cursor(cr_default);
    scr_load_game();
}