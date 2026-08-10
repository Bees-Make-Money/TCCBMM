event_inherited();
if (global.interaction_locked) exit

var _object_layer = layer
if (object_layer != "") {
	_object_layer = object_layer
}

instance_create_layer(object_x, object_y, _object_layer, object_asset, object_var_struct)