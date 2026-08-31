var bx = btn_x - btn_w/2;
var by = btn_y - btn_h/2;

if (!instance_exists(obj_key1)) {
    if (point_in_rectangle(mouse_x, mouse_y, bx, by, bx+btn_w, by+btn_h)) {
        instance_create_layer(0, 0, "Instances", obj_key1);
    }
}