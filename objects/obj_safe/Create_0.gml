solved = false;
if (scr_flag("safe_solved")) {
    if (!scr_flag("dark_key_taken")) {
        instance_create_layer(x, y + 100, "Instances", obj_dark_key);
    }
    instance_destroy();
}