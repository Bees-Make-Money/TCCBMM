if (lanterna_uv && obj_flashlight.active) {
    if (point_distance(x, y, obj_flashlight.light_x, obj_flashlight.light_y) < 120) {
        draw_self(); 
    }
}