var bx = x - btn_w/2;
var by = y - btn_h/2;

if (!instance_exists(obj_instruction1)) {
    if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx+btn_w, by+btn_h)) {
        global.meia_senha = "1 0";
        instance_create_layer(0, 0, layer, obj_instruction1);
    }
}