solved = false;
if (global.safe_solved) {
    if (!global.iron_key_taken) {
        instance_create_layer(x, y + 100, "Instances", obj_iron_key);
    }
    instance_destroy();
}