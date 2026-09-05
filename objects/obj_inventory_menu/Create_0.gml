depth = -10;
global.interaction_locked = true;
can_close = false;

slot_instances = [];

var col_start = -238;
var row_start = -106;
var spacing   = 119;
var cols      = 5;

for (var i = 0; i < 10; i++) {
    var col = i mod cols;
    var row = i div cols;

    var slot_x = x + col_start + (col * spacing);
    var slot_y = y + row_start + (row * spacing);
	
    var slot = instance_create_layer(slot_x, slot_y, "Menu", obj_inventory_slot);
    slot.slot_index = i;

    array_push(slot_instances, slot);
}