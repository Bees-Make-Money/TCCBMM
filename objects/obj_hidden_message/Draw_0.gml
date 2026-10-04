    if (!global.lens_attached) exit;
    if (!instance_exists(global.flashlight_id)) exit;
    if (!global.flashlight_id.active) exit;

    var _dist = point_distance(x, y, global.flashlight_id.light_x, global.flashlight_id.light_y);
    if (_dist > reveal_radius) exit;

    var _alpha = 1 - (_dist / reveal_radius);

    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(140, 220, 255));
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, y, message_text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);

