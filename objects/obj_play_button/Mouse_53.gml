if (point_in_rectangle(mouse_x, mouse_y, x, y, x + largura, y + altura)) {
    if !instance_exists(obj_transition_text) {
        var trans = instance_create_layer(0, 0, "UI", obj_transition_text);
        trans.next_room = rm_hall_entrada;
        trans.transition_text = "Entrando no Corredor...";
        trans.fade_in = true;
    }
}