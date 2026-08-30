solved = false
if (global.safe_solved) {
    if (!instance_exists(obj_iron_key)) {
        instance_create_layer(x, y + 100, "Instances", obj_iron_key);
    }
    
    instance_destroy();
}