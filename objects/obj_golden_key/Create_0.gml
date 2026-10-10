item_name = "Chave Dourada"
on_pickup = function() {scr_flag_set("golden_key_taken")};
image_xscale = 48 / 250;
image_yscale = 48 / 250;
if(!obj_flashlight.active){
	instance_destroy(obj_golden_key);
} 