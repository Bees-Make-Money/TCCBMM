var bx = x - btn_w/2;
var by = y - btn_h/2;

if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx+btn_w, by+btn_h)) {
    if (!instance_exists(obj_engrenagem_ui))
        instance_create_layer(0, 0, layer, obj_engrenagem_ui);
}