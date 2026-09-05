if (!can_close) exit;

var _dentro = point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom);

var _clicou_submenu = false;
if (instance_position(mouse_x, mouse_y, obj_inventory_option_select)) _clicou_submenu = true;
if (instance_position(mouse_x, mouse_y, obj_inventory_option_cancel)) _clicou_submenu = true;

if (!_dentro && !_clicou_submenu) {
    instance_destroy();
}